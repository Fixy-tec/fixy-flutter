-- ============================================================
-- Fixy - Sprint 9: cron jobs + recordatorio de deadline
-- Requiere habilitar la extension pg_cron desde:
--   Database -> Extensions -> habilita "pg_cron"
-- (En Supabase free plan esta disponible.)
-- ============================================================

-- ------------------------------------------------------------
-- 1) Funcion: enviar recordatorio 24h antes de la fecha limite
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
-- 2) Habilitar pg_cron (no-op si ya esta)
-- ------------------------------------------------------------
create extension if not exists pg_cron;

-- ------------------------------------------------------------
-- 3) Programar jobs (idempotente: borra si ya existe y crea de nuevo)
-- ------------------------------------------------------------

-- Eliminar jobs previos con el mismo nombre, si existen.
do $$
declare
  v_id bigint;
begin
  for v_id in select jobid from cron.job
              where jobname in ('fixy-auto-rate', 'fixy-deadline-reminders')
  loop
    perform cron.unschedule(v_id);
  end loop;
end $$;

-- Auto-rating de 3 estrellas tras 7 dias - todos los dias a las 3am UTC
select cron.schedule(
  'fixy-auto-rate',
  '0 3 * * *',
  $$ select public.auto_rate_pending_after_7_days(); $$
);

-- Recordatorio de deadline - todos los dias a las 9am UTC
select cron.schedule(
  'fixy-deadline-reminders',
  '0 9 * * *',
  $$ select public.send_deadline_reminders(); $$
);

-- Verificar:
--   select * from cron.job;
