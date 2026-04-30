-- ============================================================
-- Fixy - Cron jobs (pg_cron)
-- Requiere habilitar la extension pg_cron desde:
--   Database -> Extensions -> habilita "pg_cron"
-- (En Supabase free plan esta disponible.)
--
-- Las funciones invocadas (auto_rate_pending_after_7_days,
-- send_deadline_reminders) viven en 02_functions.sql.
-- ============================================================

create extension if not exists pg_cron;

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
