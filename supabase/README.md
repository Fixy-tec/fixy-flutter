# Fixy - Base de datos Supabase

## Cómo aplicar las migraciones

1. Abre tu proyecto **Fixy-db** en [Supabase Studio](https://supabase.com/dashboard).
2. Ve a **SQL Editor** → **New query**.
3. Ejecuta los archivos en este orden (uno a la vez, copia-pega y "Run"):

   1. `01_schema.sql` — crea tablas y enums
   2. `02_functions.sql` — funciones de negocio (calcular medalla, puntos, etc.)
   3. `03_triggers.sql` — triggers (auto-perfil al registrarse, notificaciones, etc.)
   4. `04_rls.sql` — políticas Row Level Security
   5. `05_seed.sql` — tags iniciales del catálogo

## Configurar Auth

En **Authentication → Providers → Email**:

- ✅ Enable Email provider
- ✅ Confirm email (recomendado)
- En **URL Configuration**, deja por defecto si solo es móvil

En **Authentication → Email Templates** (opcional, español):
- Personaliza los correos de confirmación / recuperación

## Realtime

En **Database → Replication**, habilita Realtime para:

- `notifications` (para mostrar campanita en vivo)
- `applications` (para que el creador vea nuevas postulaciones al instante)
- `requests` (para refrescar el feed)

## Cron job (Sprint 9)

Para el auto-rating de 3★ tras 7 días, en **Database → Cron Jobs**:

```sql
select cron.schedule(
  'auto-rate-pending',
  '0 3 * * *',  -- todos los días a las 3am
  $$ select public.auto_rate_pending_after_7_days(); $$
);
```

## Probar

Crea un usuario de prueba con email `@tecsup.edu.pe` desde Authentication → Users → Add user. El trigger debe crear automáticamente un row en `public.profiles`.
