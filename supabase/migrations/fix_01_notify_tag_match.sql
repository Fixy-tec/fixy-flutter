-- Fix: el trigger notify_tag_match no casteaba el literal a notification_type.
-- Ejecuta este archivo una sola vez en SQL Editor antes de re-aplicar 06_seed_demo.sql.

create or replace function public.notify_tag_match()
returns trigger language plpgsql as $$
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
