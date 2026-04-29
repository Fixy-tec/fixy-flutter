# Fixy — Flutter App

App móvil para conectar estudiantes Tecsup que necesitan asesorías o socios para proyectos.
Sistema con reputación por puntos y medallas (Hierro → Challenger).

## Stack

- **Flutter 3.41+ / Dart 3.11+** — Material 3, dark-first
- **Backend: Supabase** (auth + Postgres + Realtime + Storage)
  - Lógica crítica (puntos, medallas, auto-rating, notificaciones) vive en **triggers SQL**, NO en Dart
  - SDK oficial `supabase_flutter` maneja sesión y refresh automáticamente
- **State: flutter_riverpod v2.x** + `riverpod_annotation` (codegen)
- **Nav: go_router v14.x** con `StatefulShellRoute` para tabs principales
- **Modelos: freezed + json_serializable** (codegen)
- **UI: google_fonts (Inter), cached_network_image, flutter_svg**
- **Utils: intl (fechas en español), url_launcher (wa.me), flutter_dotenv**
- **Push: firebase_messaging** — sólo Sprint 8; tabla `device_tokens` ya existe

## Estructura de carpetas

```
lib/
  core/
    theme/        # AppTheme M3 + AppColors
    router/       # go_router + AppShell con NavigationBar
    supabase/     # cliente singleton + initSupabase()
    constants/    # reputation.dart (espejo UI de las funciones SQL)
    utils/        # validators (email Tecsup, etc.)
  features/
    auth/ feed/ requests/ applications/ profile/ ranking/ notifications/
      data/         # repositories que hablan con Supabase
      domain/       # entities (sólo si la feature lo justifica)
      presentation/
        pages/      # widgets-pantalla
        providers/  # Riverpod providers
  shared/
    widgets/      # MedalBadge, TagChip, RequestCard, etc.
    models/       # modelos compartidos con freezed
```

**Regla:** estructura por features, no por capas globales. `domain/` es opcional en features simples.

## Backend (Supabase)

- Proyecto: `Fixy-db`
- Migraciones SQL: [supabase/migrations/](supabase/migrations/) (ejecutar en orden 01→05)
- Tablas: `profiles, tags, user_tags, requests, request_tags, applications, ratings, point_log, notifications, device_tokens`
- RLS habilitado en todas las tablas — cada usuario solo edita lo suyo
- Auth: Supabase Auth con email `@tecsup.edu.pe` (validado en cliente, en CHECK constraint y en trigger)
- Realtime habilitado en: `notifications`, `applications`, `requests`

## Colores (Material 3)

Primary `#1A4CA3` · Secondary `#057F78` — vía `ColorScheme.fromSeed()`.
Tema dark por defecto (matches del prototipo).

## Reglas de código

- **Lógica de negocio crítica → en SQL** (puntos, cambio de medalla, validaciones de RLS).
  No replicar en Dart cosas que un cliente malicioso podría manipular.
- **Estados de UI con `AsyncValue`** de Riverpod (cubre loading/error/data sin dartz).
- **Lógica de negocio NUNCA en presentation/** — usar providers + repositories.
- **DI**: la maneja Riverpod. NO usar `get_it`, `injectable`.
- **HTTP**: el cliente Supabase es suficiente. NO añadir `dio`.
- **Storage**: `supabase_flutter` persiste sesión solo. NO añadir `flutter_secure_storage` ni `Hive` salvo necesidad real.
- **Después de cambios**: `flutter analyze`
- **Codegen**: `dart run build_runner build --delete-conflicting-outputs`
- **Comentarios**: en español si son necesarios. Código (identificadores) en inglés.
- **`.env`**: nunca commitear; ya está en `.gitignore`.

## Reputación (resumen — la fuente de verdad es SQL)

| Dificultad | Puntos base | Medalla | Rango |
|---|---|---|---|
| 1 | +50 | Hierro | 0–299 |
| 2 | +100 | Bronce | 300–799 |
| 3 | +180 | Plata | 800–1799 |
| 4 | +280 | Oro | 1800–3499 |
| 5 | +400 | Diamante | 3500–5999 |
|   |   | Maestro | 6000–9999 |
|   |   | Challenger | 10000+ |

Modificadores: 5★×1.5 · 4★×1.2 · 3★×1.0 · 2★ −30 · 1★ −80 · creador 20% del base.
Implementación canónica: [supabase/migrations/02_functions.sql](supabase/migrations/02_functions.sql).
Espejo en Dart (sólo para UI): [lib/core/constants/reputation.dart](lib/core/constants/reputation.dart).

## Plan de sprints

1. ✅ Setup (theme + router + Supabase client)
2. Auth (login/registro con email Tecsup)
3. Feed Inicio + modelos
4. Crear solicitud + Mis Solicitudes
5. Postulaciones + WhatsApp deeplink
6. Perfil + Ranking
7. Calificaciones
8. Notificaciones (in-app + FCM)
9. Pulido + auto-rating cron
10. Demo

## Referencias del proyecto

- Documento general (visión y RFs): [docs/Fixy - Informe General.pdf](docs/Fixy%20-%20Informe%20General.pdf)
- Prototipo visual: [Prototipo/](Prototipo/)
- Migraciones SQL + instrucciones: [supabase/README.md](supabase/README.md)
