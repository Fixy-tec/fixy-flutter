-- ============================================================
-- Fixy - Row Level Security (RLS)
-- Cada usuario solo ve/edita lo que le corresponde
-- ============================================================

alter table public.profiles       enable row level security;
alter table public.tags           enable row level security;
alter table public.user_tags      enable row level security;
alter table public.requests       enable row level security;
alter table public.request_tags   enable row level security;
alter table public.applications   enable row level security;
alter table public.ratings        enable row level security;
alter table public.point_log      enable row level security;
alter table public.notifications  enable row level security;
alter table public.device_tokens  enable row level security;

-- ------------------------------------------------------------
-- PROFILES: lectura publica (perfil publico), edicion solo propio
-- ------------------------------------------------------------
create policy "profiles_select_all"
  on public.profiles for select
  using (true);

create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- el INSERT lo hace el trigger handle_new_auth_user; bloqueamos manual
create policy "profiles_no_manual_insert"
  on public.profiles for insert
  with check (auth.uid() = id);

-- ------------------------------------------------------------
-- TAGS: lectura publica, insercion solo autenticados
-- ------------------------------------------------------------
create policy "tags_select_all"
  on public.tags for select using (true);

create policy "tags_insert_authenticated"
  on public.tags for insert
  with check (auth.uid() is not null and (created_by = auth.uid() or created_by is null));

-- ------------------------------------------------------------
-- USER_TAGS: ver todos, modificar solo propios
-- ------------------------------------------------------------
create policy "user_tags_select_all"
  on public.user_tags for select using (true);

create policy "user_tags_insert_own"
  on public.user_tags for insert
  with check (auth.uid() = user_id);

create policy "user_tags_delete_own"
  on public.user_tags for delete
  using (auth.uid() = user_id);

-- ------------------------------------------------------------
-- REQUESTS: lectura publica, escritura solo del creador
-- ------------------------------------------------------------
create policy "requests_select_all"
  on public.requests for select using (true);

create policy "requests_insert_own"
  on public.requests for insert
  with check (auth.uid() = creator_id);

create policy "requests_update_own"
  on public.requests for update
  using (auth.uid() = creator_id)
  with check (auth.uid() = creator_id);

create policy "requests_delete_own"
  on public.requests for delete
  using (auth.uid() = creator_id);

-- ------------------------------------------------------------
-- REQUEST_TAGS: ver todos, modificar solo si eres creador del request
-- ------------------------------------------------------------
create policy "request_tags_select_all"
  on public.request_tags for select using (true);

create policy "request_tags_modify_own"
  on public.request_tags for all
  using (
    exists (
      select 1 from public.requests r
      where r.id = request_tags.request_id and r.creator_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.requests r
      where r.id = request_tags.request_id and r.creator_id = auth.uid()
    )
  );

-- ------------------------------------------------------------
-- APPLICATIONS: ver propias y las de mis requests
-- ------------------------------------------------------------
create policy "applications_select_visible"
  on public.applications for select
  using (
    auth.uid() = applicant_id
    or exists (
      select 1 from public.requests r
      where r.id = applications.request_id and r.creator_id = auth.uid()
    )
  );

create policy "applications_insert_own"
  on public.applications for insert
  with check (
    auth.uid() = applicant_id
    and not exists (
      select 1 from public.requests r
      where r.id = applications.request_id and r.creator_id = auth.uid()
    )
  );

-- el creador del request puede actualizar el status (aprobar/rechazar)
-- el postulante puede cancelar (eliminar)
create policy "applications_update_by_request_creator"
  on public.applications for update
  using (
    exists (
      select 1 from public.requests r
      where r.id = applications.request_id and r.creator_id = auth.uid()
    )
  );

create policy "applications_delete_own"
  on public.applications for delete
  using (auth.uid() = applicant_id);

-- ------------------------------------------------------------
-- RATINGS: lectura publica (para mostrar en perfil)
-- escritura solo si participaste en el request y esta completada
-- ------------------------------------------------------------
create policy "ratings_select_all"
  on public.ratings for select using (true);

create policy "ratings_insert_own"
  on public.ratings for insert
  with check (
    auth.uid() = rater_id
    and exists (
      select 1 from public.requests r
      left join public.applications a
        on a.request_id = r.id and a.status = 'aprobada'
      where r.id = ratings.request_id
        and r.status = 'completada'
        and (
          (auth.uid() = r.creator_id and ratings.rated_id = a.applicant_id)
          or
          (auth.uid() = a.applicant_id and ratings.rated_id = r.creator_id)
        )
    )
  );

-- ------------------------------------------------------------
-- POINT_LOG: solo el dueño puede ver su historial
-- ------------------------------------------------------------
create policy "point_log_select_own"
  on public.point_log for select
  using (auth.uid() = user_id);

-- (no hay insert manual; lo hace apply_points_change con security definer)

-- ------------------------------------------------------------
-- NOTIFICATIONS: solo el dueño
-- ------------------------------------------------------------
create policy "notifications_select_own"
  on public.notifications for select
  using (auth.uid() = user_id);

create policy "notifications_update_own"
  on public.notifications for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "notifications_delete_own"
  on public.notifications for delete
  using (auth.uid() = user_id);

-- ------------------------------------------------------------
-- DEVICE_TOKENS: solo el dueño
-- ------------------------------------------------------------
create policy "device_tokens_all_own"
  on public.device_tokens for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
