-- ============================================================
-- Fixy - Funciones de negocio
-- ============================================================

-- Calcula medalla a partir de puntos totales (Hierro -> Challenger)
create or replace function public.calculate_medal(points int)
returns medal_tier
language sql
immutable
as $$
  select case
    when points >= 10000 then 'challenger'::medal_tier
    when points >= 6000  then 'maestro'::medal_tier
    when points >= 3500  then 'diamante'::medal_tier
    when points >= 1800  then 'oro'::medal_tier
    when points >= 800   then 'plata'::medal_tier
    when points >= 300   then 'bronce'::medal_tier
    else 'hierro'::medal_tier
  end;
$$;

-- Puntos base por nivel de dificultad
create or replace function public.base_points_for_level(lvl int)
returns int
language sql
immutable
as $$
  select case lvl
    when 1 then 50
    when 2 then 100
    when 3 then 180
    when 4 then 280
    when 5 then 400
    else 0
  end;
$$;

-- Calcula puntos a otorgar segun estrellas y si es creador o postulante
-- 5*: x1.5  | 4*: x1.2  | 3*: x1.0  | 2*: -30 fijo  | 1*: -80 fijo
-- Creador recibe 20% del base (independiente de modificadores)
create or replace function public.compute_rating_points(
  base int,
  stars int,
  is_creator boolean
)
returns int
language plpgsql
immutable
as $$
declare
  result int;
begin
  if is_creator then
    -- el creador siempre recibe 20% del base si participa
    return round(base * 0.20)::int;
  end if;

  result := case stars
    when 5 then round(base * 1.5)::int
    when 4 then round(base * 1.2)::int
    when 3 then base
    when 2 then -30
    when 1 then -80
    else 0
  end;

  return result;
end;
$$;

-- Aplica delta de puntos a un usuario y registra en point_log
-- Tambien actualiza la medalla y dispara notificacion si cambia
create or replace function public.apply_points_change(
  p_user_id    uuid,
  p_delta      int,
  p_reason     text,
  p_rating_id  uuid default null,
  p_request_id uuid default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_old_points int;
  v_new_points int;
  v_old_medal  medal_tier;
  v_new_medal  medal_tier;
begin
  select total_points, medal into v_old_points, v_old_medal
  from public.profiles
  where id = p_user_id
  for update;

  v_new_points := greatest(0, v_old_points + p_delta);
  v_new_medal  := public.calculate_medal(v_new_points);

  update public.profiles
  set total_points = v_new_points,
      medal        = v_new_medal,
      updated_at   = now()
  where id = p_user_id;

  insert into public.point_log (user_id, rating_id, request_id, delta, reason, medal_before, medal_after)
  values (p_user_id, p_rating_id, p_request_id, p_delta, p_reason, v_old_medal, v_new_medal);

  if v_old_medal <> v_new_medal then
    insert into public.notifications (user_id, type, title, body, related_user_id, data)
    values (
      p_user_id,
      'medal_changed',
      case when v_new_medal::text > v_old_medal::text
           then 'Has subido a ' || v_new_medal::text
           else 'Has bajado a ' || v_new_medal::text end,
      'Tu medalla cambio de ' || v_old_medal::text || ' a ' || v_new_medal::text,
      p_user_id,
      jsonb_build_object('from', v_old_medal, 'to', v_new_medal)
    );
  end if;
end;
$$;

-- Recalcula avg_rating y ratings_count del usuario calificado
create or replace function public.refresh_user_rating_stats(p_user_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.profiles p
  set ratings_count = sub.cnt,
      avg_rating    = coalesce(sub.avg, 0)
  from (
    select count(*)::int as cnt, avg(stars)::numeric(3,2) as avg
    from public.ratings
    where rated_id = p_user_id
  ) sub
  where p.id = p_user_id;
end;
$$;

-- Auto-rating de 3 estrellas tras 7 dias de cierre sin calificar
-- (se invoca via Supabase Cron / pg_cron - configurar en Sprint 9)
create or replace function public.auto_rate_pending_after_7_days()
returns void
language plpgsql
as $$
declare
  r record;
begin
  -- Encontrar requests completadas hace +7 dias donde falta una calificacion
  for r in
    select req.id as request_id,
           req.creator_id,
           app.applicant_id,
           req.updated_at as completed_at
    from public.requests req
    join public.applications app
      on app.request_id = req.id and app.status = 'aprobada'
    where req.status = 'completada'
      and req.updated_at < now() - interval '7 days'
  loop
    -- Creador no califico al postulante
    if not exists (
      select 1 from public.ratings
      where request_id = r.request_id
        and rater_id   = r.creator_id
        and rated_id   = r.applicant_id
    ) then
      insert into public.ratings (request_id, rater_id, rated_id, stars, comment)
      values (r.request_id, r.creator_id, r.applicant_id, 3, '[Auto-asignado tras 7 dias]');
    end if;

    -- Postulante no califico al creador
    if not exists (
      select 1 from public.ratings
      where request_id = r.request_id
        and rater_id   = r.applicant_id
        and rated_id   = r.creator_id
    ) then
      insert into public.ratings (request_id, rater_id, rated_id, stars, comment)
      values (r.request_id, r.applicant_id, r.creator_id, 3, '[Auto-asignado tras 7 dias]');
    end if;
  end loop;
end;
$$;

-- Recordatorio 24h antes de la fecha limite (RF-N06)
create or replace function public.send_deadline_reminders()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.notifications (user_id, type, title, body, related_request_id)
  select req.creator_id,
         'deadline_reminder'::notification_type,
         'Tu solicitud vence pronto',
         req.title || ' vence manana',
         req.id
  from public.requests req
  where req.status in ('abierta', 'en_revision', 'en_proceso')
    and req.deadline = (now() + interval '1 day')::date
    and not exists (
      select 1 from public.notifications n
      where n.related_request_id = req.id
        and n.type = 'deadline_reminder'
        and n.created_at >= now() - interval '2 days'
    );
end;
$$;

-- Trigger: al insertar un profile no creado por handle_new_user, ya queda listo
-- Trigger: al registrarse en auth.users, copiar a profiles automaticamente
create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1))
  );
  return new;
end;
$$;
