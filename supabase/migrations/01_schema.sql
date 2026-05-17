-- ============================================================
-- Fixy - Schema base
-- Ejecutar en orden: 01_schema -> 02_functions -> 03_triggers -> 04_rls -> 05_seed
-- ============================================================

-- Extensiones
create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

-- ============================================================
-- ENUMS
-- ============================================================
create type request_type as enum ('asesoria', 'proyecto');
create type request_status as enum ('abierta', 'en_revision', 'en_proceso', 'completada', 'cancelada');
create type application_status as enum ('pendiente', 'aprobada', 'rechazada');
create type medal_tier as enum ('hierro', 'bronce', 'plata', 'oro', 'diamante', 'maestro', 'challenger');
create type notification_type as enum (
  'new_application',
  'application_approved',
  'application_rejected',
  'request_completed',
  'tag_match',
  'deadline_reminder',
  'medal_changed'
);

-- ============================================================
-- PROFILES (extiende auth.users de Supabase)
-- ============================================================
create table public.profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  full_name       text not null,
  email           text not null unique,
  career          text,                          -- ej: "Desarrollo de Software"
  cycle           int check (cycle between 1 and 10),
  bio             text,
  avatar_url      text,
  avatar_slug     text check (avatar_slug in ('arte','cyborg','hacker','karate','money','pirata')),
  whatsapp_number text,                          -- visible solo cuando se aprueba postulacion
  portfolio_url   text,
  linkedin_url    text,
  github_url      text,
  total_points    int not null default 0,
  medal           medal_tier not null default 'hierro',
  avg_rating      numeric(3,2) not null default 0,
  ratings_count   int not null default 0,
  is_active       boolean not null default true,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  -- email institucional Tecsup
  constraint email_tecsup check (email ~* '^[a-z0-9._%+-]+@tecsup\.edu\.pe$')
);

create index idx_profiles_total_points on public.profiles(total_points desc);
create index idx_profiles_medal on public.profiles(medal);

-- ============================================================
-- TAGS (catalogo + custom)
-- ============================================================
create table public.tags (
  id          uuid primary key default uuid_generate_v4(),
  name        text not null unique,
  slug        text not null unique,
  is_custom   boolean not null default false,
  created_by  uuid references public.profiles(id) on delete set null,
  created_at  timestamptz not null default now()
);

create index idx_tags_slug on public.tags(slug);

-- ============================================================
-- USER_TAGS (especialidades del usuario)
-- ============================================================
create table public.user_tags (
  user_id     uuid not null references public.profiles(id) on delete cascade,
  tag_id      uuid not null references public.tags(id) on delete cascade,
  assigned_at timestamptz not null default now(),
  primary key (user_id, tag_id)
);

create index idx_user_tags_tag on public.user_tags(tag_id);

-- ============================================================
-- REQUESTS (solicitudes de asesoria/proyecto)
-- ============================================================
create table public.requests (
  id                    uuid primary key default uuid_generate_v4(),
  creator_id            uuid not null references public.profiles(id) on delete cascade,
  type                  request_type not null,
  title                 text not null check (char_length(title) <= 80),
  description           text not null check (char_length(description) <= 1000),
  difficulty_level      int not null check (difficulty_level between 1 and 5),
  base_points           int not null,                       -- calculado en trigger
  economic_benefit      numeric(10,2),                      -- null = voluntario
  participants_needed   int not null default 1 check (participants_needed >= 1),
  status                request_status not null default 'abierta',
  deadline              date,
  published_at          timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

create index idx_requests_status on public.requests(status);
create index idx_requests_creator on public.requests(creator_id);
create index idx_requests_published on public.requests(published_at desc);
create index idx_requests_type on public.requests(type);

-- ============================================================
-- REQUEST_TAGS
-- ============================================================
create table public.request_tags (
  request_id  uuid not null references public.requests(id) on delete cascade,
  tag_id      uuid not null references public.tags(id) on delete cascade,
  primary key (request_id, tag_id)
);

create index idx_request_tags_tag on public.request_tags(tag_id);

-- ============================================================
-- APPLICATIONS (postulaciones)
-- ============================================================
create table public.applications (
  id            uuid primary key default uuid_generate_v4(),
  request_id    uuid not null references public.requests(id) on delete cascade,
  applicant_id  uuid not null references public.profiles(id) on delete cascade,
  message       text check (char_length(message) <= 300),
  status        application_status not null default 'pendiente',
  applied_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  unique (request_id, applicant_id)
);

create index idx_applications_request on public.applications(request_id);
create index idx_applications_applicant on public.applications(applicant_id);
create index idx_applications_status on public.applications(status);

-- ============================================================
-- RATINGS (calificaciones bidireccionales)
-- ============================================================
create table public.ratings (
  id              uuid primary key default uuid_generate_v4(),
  request_id      uuid not null references public.requests(id) on delete cascade,
  rater_id        uuid not null references public.profiles(id) on delete cascade,
  rated_id        uuid not null references public.profiles(id) on delete cascade,
  stars           int not null check (stars between 1 and 5),
  comment         text check (char_length(comment) <= 200),
  points_awarded  int not null default 0,
  created_at      timestamptz not null default now(),
  unique (request_id, rater_id, rated_id),
  check (rater_id <> rated_id)
);

create index idx_ratings_rated on public.ratings(rated_id);
create index idx_ratings_request on public.ratings(request_id);

-- ============================================================
-- POINT_LOG (historial de puntos)
-- ============================================================
create table public.point_log (
  id            uuid primary key default uuid_generate_v4(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  rating_id     uuid references public.ratings(id) on delete set null,
  request_id    uuid references public.requests(id) on delete set null,
  delta         int not null,
  reason        text not null,
  medal_before  medal_tier not null,
  medal_after   medal_tier not null,
  created_at    timestamptz not null default now()
);

create index idx_point_log_user on public.point_log(user_id, created_at desc);

-- ============================================================
-- NOTIFICATIONS (in-app)
-- ============================================================
create table public.notifications (
  id                  uuid primary key default uuid_generate_v4(),
  user_id             uuid not null references public.profiles(id) on delete cascade,
  type                notification_type not null,
  title               text not null,
  body                text,
  related_request_id  uuid references public.requests(id) on delete cascade,
  related_user_id     uuid references public.profiles(id) on delete cascade,
  data                jsonb,
  is_read             boolean not null default false,
  created_at          timestamptz not null default now()
);

create index idx_notifications_user on public.notifications(user_id, created_at desc);
create index idx_notifications_unread on public.notifications(user_id) where is_read = false;

-- ============================================================
-- DEVICE_TOKENS (FCM - se llena en Sprint 8)
-- ============================================================
create table public.device_tokens (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid not null references public.profiles(id) on delete cascade,
  token       text not null unique,
  platform    text not null check (platform in ('android', 'ios', 'web')),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index idx_device_tokens_user on public.device_tokens(user_id);
