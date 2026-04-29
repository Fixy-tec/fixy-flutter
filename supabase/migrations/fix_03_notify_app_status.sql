-- Fix: notify_application_status_change tenia 5 columnas en INSERT pero
-- solo 4 valores (faltaba related_request_id en el VALUES).
-- Ejecuta este archivo UNA SOLA VEZ en Supabase SQL Editor.

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
