-- ============================================================
-- Fixy - Triggers
-- ============================================================

-- ------------------------------------------------------------
-- Auto crear profile cuando se registra en auth.users
-- ------------------------------------------------------------
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_auth_user();

-- ------------------------------------------------------------
-- updated_at automatico
-- ------------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create trigger trg_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

create trigger trg_requests_updated_at
  before update on public.requests
  for each row execute function public.set_updated_at();

create trigger trg_applications_updated_at
  before update on public.applications
  for each row execute function public.set_updated_at();

create trigger trg_device_tokens_updated_at
  before update on public.device_tokens
  for each row execute function public.set_updated_at();

-- ------------------------------------------------------------
-- Calcular base_points al insertar request
-- ------------------------------------------------------------
create or replace function public.set_request_base_points()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  new.base_points := public.base_points_for_level(new.difficulty_level);
  return new;
end;
$$;

create trigger trg_request_base_points
  before insert or update of difficulty_level on public.requests
  for each row execute function public.set_request_base_points();

-- ------------------------------------------------------------
-- Notificar al creador cuando hay nueva postulacion
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
    'new_application',
    v_applicant || ' se postulo a tu solicitud',
    v_title,
    new.request_id,
    new.applicant_id
  );
  return new;
end;
$$;

create trigger trg_notify_new_application
  after insert on public.applications
  for each row execute function public.notify_new_application();

-- ------------------------------------------------------------
-- Notificar al postulante cuando cambia el estado de su postulacion
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
      v_title || ' - WhatsApp desbloqueado',
      new.request_id
    );
  elsif new.status = 'rechazada' then
    insert into public.notifications (user_id, type, title, body, related_request_id)
    values (
      new.applicant_id,
      'application_rejected'::notification_type,
      'Tu postulacion fue rechazada',
      v_title,
      new.request_id
    );
  end if;
  return new;
end;
$$;

create trigger trg_notify_application_status
  after update of status on public.applications
  for each row execute function public.notify_application_status_change();

-- ------------------------------------------------------------
-- Solo permitir 1 postulacion aprobada por solicitud
-- y mover request a en_proceso al aprobar
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

create trigger trg_handle_application_approval
  before update of status on public.applications
  for each row execute function public.handle_application_approval();

-- ------------------------------------------------------------
-- Al insertar rating: calcular puntos y aplicarlos
-- ------------------------------------------------------------
create or replace function public.process_new_rating()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request    public.requests%rowtype;
  v_is_creator boolean;
  v_points     int;
begin
  select * into v_request from public.requests where id = new.request_id;

  -- es creador el que esta siendo calificado?
  v_is_creator := (new.rated_id = v_request.creator_id);

  v_points := public.compute_rating_points(v_request.base_points, new.stars, v_is_creator);

  -- guardar en el rating
  new.points_awarded := v_points;

  return new;
end;
$$;

create trigger trg_process_new_rating
  before insert on public.ratings
  for each row execute function public.process_new_rating();

-- after insert: aplicar los puntos y refrescar stats
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

create trigger trg_apply_rating_effects
  after insert on public.ratings
  for each row execute function public.apply_rating_effects();

-- ------------------------------------------------------------
-- Notificar tag-match al publicar nuevo request
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

create trigger trg_notify_tag_match
  after insert on public.request_tags
  for each row execute function public.notify_tag_match();
