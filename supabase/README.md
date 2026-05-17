# Fixy — Base de datos Supabase

Documentación de la base de datos de Fixy (PostgreSQL + Auth + Realtime + RLS + pg_cron, gestionado por Supabase).

## 📊 Resumen

- **10 tablas** con Row Level Security habilitado
- **6 enumeraciones** (`request_type`, `request_status`, `application_status`, `medal_tier`, `notification_type`, etc.)
- **13 triggers** automáticos (perfil al registrarse, cálculo de puntos, notificaciones, etc.)
- **2 cron jobs** diarios (auto-rating + recordatorios de deadline)
- **8 archivos de migración** idempotentes

## 🚀 Cómo aplicar las migraciones

1. Abre tu proyecto en [Supabase Studio](https://supabase.com/dashboard).
2. Ve a **SQL Editor** → **New query**.
3. Ejecuta los archivos **en orden** (uno a la vez: copia-pega y "Run"):

| # | Archivo | Qué hace |
|---|---|---|
| 1 | `01_schema.sql` | Crea tablas, enums e índices |
| 2 | `02_functions.sql` | Funciones de negocio (medallas, puntos, deadline reminder, auto-rating) |
| 3 | `03_triggers.sql` | Triggers (auto-perfil, notificaciones, cálculo de puntos) |
| 4 | `04_rls.sql` | Políticas Row Level Security en las 10 tablas |
| 5 | `05_seed.sql` | Catálogo inicial de ~40 tags |
| 6 | `06_seed_demo.sql` | *(opcional)* 5 usuarios ficticios + 8 solicitudes de demo |
| 7 | `07_cron.sql` | Jobs diarios (auto-rating + deadline reminders) — requiere `pg_cron` |
| 8 | `08_avatar.sql` | Columnas `avatar_slug` y `github_url` en `profiles` (v1.1+) |

> Para una instalación nueva basta con aplicar 01→08 en orden. Las migraciones son idempotentes (usan `if not exists` / `on conflict`).

## ⚙️ Configurar Auth

En **Authentication → Providers → Email**:

- ✅ **Enable Email provider**
- ⚠️ Para desarrollo: desactivar **Confirm email**. Reactivar para producción.

## 🔌 Realtime

En **Database → Replication** (o cada tabla → "Enable Realtime"), habilita realtime para:

- `notifications` — campana en vivo con badge en el Dashboard
- `applications` — actualización inmediata cuando un postulante aplica
- `requests` — refresco del feed sin recargar

## 🔧 Extensiones requeridas

En **Database → Extensions**, habilita:

- `pg_cron` — necesaria para `07_cron.sql` (jobs diarios)
- `pgcrypto` — ya viene habilitada por defecto, usada para `gen_random_uuid()`

## 🧪 Probar la instalación

Crea un usuario manualmente:

1. **Authentication → Users → Add user**
2. Email: `prueba@tecsup.edu.pe` · Password: cualquiera
3. Verifica en **Table Editor → profiles** que aparezca la fila automáticamente (el trigger `on_auth_user_created` la inserta).

## 🛡 Seguridad (RLS)

| Tabla | Lectura | Escritura |
|---|---|---|
| `profiles` | Pública | Solo el dueño |
| `tags` | Pública | Insert por autenticados |
| `user_tags` | Pública | Solo el dueño |
| `requests` | Pública | Solo el creador |
| `request_tags` | Pública | Solo el creador del request |
| `applications` | Postulante + creador del request | Postulante (delete) / creador (update) |
| `ratings` | Pública | Participantes de un request completado |
| `point_log` | Solo el dueño | Solo via SECURITY DEFINER |
| `notifications` | Solo el dueño | Solo via SECURITY DEFINER |
| `device_tokens` | Solo el dueño | Solo el dueño |

Las funciones que requieren escribir en `notifications`, `point_log` o `profiles` desde triggers están marcadas `SECURITY DEFINER` para bypaspear RLS de forma controlada.

## ⏰ Cron jobs

| Job | Schedule | Función invocada |
|---|---|---|
| `fixy-auto-rate` | `0 3 * * *` UTC | `auto_rate_pending_after_7_days()` |
| `fixy-deadline-reminders` | `0 9 * * *` UTC | `send_deadline_reminders()` |

Verificar los jobs activos:

```sql
SELECT jobname, schedule, active FROM cron.job;
```
