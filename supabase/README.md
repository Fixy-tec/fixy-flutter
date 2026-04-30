# Fixy - Base de datos Supabase

## Cómo aplicar las migraciones

1. Abre tu proyecto en [Supabase Studio](https://supabase.com/dashboard).
2. Ve a **SQL Editor** → **New query**.
3. Ejecuta los archivos en este orden (uno a la vez, copia-pega y "Run"):

   1. `01_schema.sql` — tablas y enums
   2. `02_functions.sql` — funciones de negocio (medallas, puntos, deadline reminder, auto-rating)
   3. `03_triggers.sql` — triggers (auto-perfil, notificaciones, ratings, etc.)
   4. `04_rls.sql` — políticas Row Level Security
   5. `05_seed.sql` — catálogo inicial de tags
   6. `06_seed_demo.sql` *(opcional)* — 5 usuarios ficticios + 8 solicitudes de demo
   7. `07_cron.sql` — jobs diarios (auto-rating + deadline reminders)

## Configurar Auth

En **Authentication → Providers → Email**:

- ✅ Enable Email provider
- ⚠️ Para desarrollo: desactivar **Confirm email** (más cómodo). Reactivar para producción.

## Realtime

En **Database → Replication** (o la tabla individual → "Enable Realtime"), habilita:

- `notifications` — para campanita en vivo y badge
- `applications` — para que el creador vea nuevas postulaciones al instante
- `requests` — para refrescar el feed

## Extensiones requeridas

- `pg_cron` (Database → Extensions) — necesaria para `07_cron.sql`

## Probar

Crea un usuario con email `@tecsup.edu.pe` desde Authentication → Users → Add user. El trigger `on_auth_user_created` debe crear automáticamente un row en `public.profiles`.
