-- ============================================================
-- Fix: las funciones de trigger que escriben en notifications,
-- point_log y profiles deben correr con SECURITY DEFINER porque
-- esas tablas no tienen policies de INSERT para el usuario final.
-- (RLS bloquea cualquier insert hecho desde un trigger por defecto.)
--
-- Ejecuta este archivo UNA SOLA VEZ en Supabase SQL Editor.
-- ============================================================

-- ------------------------------------------------------------
-- 1) Notificacion al crear postulacion
-- ------------------------------------------------------------
create or replace function public.notify_new_application()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_creator_id uuid;
  v_title      text;
  v_applicant  text;
begin
  select r.creator_id, r.title into v_creator_id, v_title
  from public.requests r where r.id = new.request_id;

  select p.full_name into v_applicant
  from public.profiles p where p.id = new.applicant_id;

  insert into public.notifications (user_id, type, title, body, related_request_id, related_user_id)
  values (
    v_creator_id,
    'new_application'::notification_type,
    v_applicant || ' se postulo a tu solicitud',
    v_title,
    new.request_id,
    new.applicant_id
  );
  return new;
end;
$$;

-- ------------------------------------------------------------
-- 2) Notificacion al cambiar estado de postulacion
-- ------------------------------------------------------------
create or replace function public.notify_application_status_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_title text;
begin
  if new.status = old.status then return new; end if;

  select r.title into v_title from public.requests r where r.id = new.request_id;

  if new.status = 'aprobada' then
    insert into public.notifications (user_id, type, title, body, related_request_id)
    values (
      new.applicant_id,
      'application_approved'::notification_type,
      'Tu postulacion fue aprobada',
      v_title || ' - WhatsApp desbloqueado'
    );
  elsif new.status = 'rechazada' then
    insert into public.notifications (user_id, type, title, body, related_request_id)
    values (
      new.applicant_id,
      'application_rejected'::notification_type,
      'Tu postulacion fue rechazada',
      v_title
    );
  end if;
  return new;
end;
$$;

-- ------------------------------------------------------------
-- 3) Notificacion de tag-match al publicar nueva solicitud
-- ------------------------------------------------------------
create or replace function public.notify_tag_match()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.notifications (user_id, type, title, body, related_request_id)
  select distinct ut.user_id,
         'tag_match'::notification_type,
         'Nueva solicitud que coincide con tus tags',
         (select title from public.requests where id = new.request_id),
         new.request_id
  from public.user_tags ut
  join public.requests req on req.id = new.request_id
  where ut.tag_id = new.tag_id
    and ut.user_id <> req.creator_id;
  return new;
end;
$$;

-- ------------------------------------------------------------
-- 4) Aplicar cambio de puntos (escribe en profiles, point_log, notifications)
-- ------------------------------------------------------------
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
      'medal_changed'::notification_type,
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

-- ------------------------------------------------------------
-- 5) Refrescar stats de rating (escribe en profiles)
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
-- 6) Aplicar efectos de rating (llama a las dos anteriores)
-- ------------------------------------------------------------
create or replace function public.apply_rating_effects()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.apply_points_change(
    new.rated_id,
    new.points_awarded,
    'Calificacion ' || new.stars || ' estrellas',
    new.id,
    new.request_id
  );
  perform public.refresh_user_rating_stats(new.rated_id);
  return new;
end;
$$;

-- ------------------------------------------------------------
-- 7) Mover request a en_proceso al aprobar postulacion
--    (escribe en requests; el creador SI puede pero el postulante no,
--     asi que necesita SECURITY DEFINER cuando lo dispara el creador
--     desde un update de su propia application)
-- ------------------------------------------------------------
create or replace function public.handle_application_approval()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_already int;
begin
  if new.status = 'aprobada' and (old.status is null or old.status <> 'aprobada') then
    select count(*) into v_already
    from public.applications
    where request_id = new.request_id
      and status     = 'aprobada'
      and id        <> new.id;

    if v_already > 0 then
      raise exception 'Ya existe una postulacion aprobada para esta solicitud';
    end if;

    update public.requests
    set status = 'en_proceso'
    where id = new.request_id and status in ('abierta', 'en_revision');
  end if;
  return new;
end;
$$;
