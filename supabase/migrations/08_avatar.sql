-- ============================================================
-- v1.1 - Agregar columnas avatar_slug y github_url a profiles
-- ============================================================
alter table public.profiles
  add column if not exists avatar_slug text
    check (avatar_slug in ('arte','cyborg','hacker','karate','money','pirata')),
  add column if not exists github_url text;
