# Changelog

Todos los cambios notables a este proyecto se documentan aquí.
Sigue el formato de [Keep a Changelog](https://keepachangelog.com/es/1.1.0/).

## [1.0.0] - 2026-04-30

Primera versión estable de Fixy. Implementa el flujo completo end-to-end:
autenticación, feed, postulaciones, calificaciones, medallas, ranking,
notificaciones realtime y cron jobs.

### Added — Sprint 1: Setup base
- Proyecto Flutter (Android + iOS) con Material 3 dark/light según sistema
- Stack: Riverpod, go_router, freezed, supabase_flutter, google_fonts
- Schema SQL completo (10 tablas + enums + RLS + funciones + triggers)
- Cliente Supabase con `.env` y flow PKCE
- Router con `StatefulShellRoute` (Inicio / Solicitudes / Ranking / Perfil)
- Tema M3 con seed `#1A4CA3` / secondary `#057F78`

### Added — Sprint 2: Autenticación
- Login y Registro con validación de email `@tecsup.edu.pe`
- AuthRepository con signIn / signUp / signOut / fetchCurrentProfile
- Auth guard reactivo en go_router
- Mensajes de error traducidos al español

### Added — Sprint 3: Feed Inicio
- Feed con joins anidados a profiles + tags + applications count
- Filtros: Todo / Asesorías / Proyectos / Recomendados (intersección de tags)
- Widgets: TagChip, MedalBadge, RequestCard
- Pull-to-refresh, header personalizado con saludo
- Seed de demo con 5 usuarios ficticios y 8 solicitudes

### Added — Sprint 4: Crear solicitud + Mis solicitudes
- CreateRequestPage con form completo (tipo, título, descripción, tags
  multi-select, dificultad 1-5, beneficio S/, fecha límite)
- Preview en vivo de puntos base según dificultad
- MyRequestsPage con TabBar: Postulaciones / Creadas / En proceso / Completadas
- StatusChip widget con todos los estados

### Added — Sprint 5: Postulaciones + WhatsApp
- RequestDetailPage con vista diferenciada para creador y postulante
- ApplySheet con mensaje de presentación (300 chars)
- ApplicantCard con avatar, medalla, rating, mensaje + botones aceptar/rechazar
- WhatsApp deeplink al aprobar postulante
- Editor de número de WhatsApp en perfil
- Botón "Marcar como completada" con confirmación

### Added — Sprint 6: Perfil completo + Ranking
- Perfil con hero, progreso a la siguiente medalla, 3 stat cards
- Editor de perfil completo (nombre, carrera, ciclo, bio, portfolio, LinkedIn)
- Editor de especialidades (tags) multi-selección
- Lista de últimas calificaciones recibidas
- Ranking con filtros por área (Global, Flutter, Redes, Matemáticas, etc.)
- Card "Tu posición" con # / pts / medalla / delta semanal
- Podio con colores oro / plata / bronce

### Added — Sprint 7: Calificaciones
- RatingSheet con 5 estrellas tap-ables y descripción del modificador en vivo
- Trigger SQL aplica los puntos automáticamente al insertar el rating
- Panel "Calificar" en el detalle cuando status = completada
- Indicador "Pendiente de calificar" en tab Completadas

### Added — Sprint 8: Notificaciones in-app
- Tabla `notifications` poblada por triggers (sin Firebase)
- Stream realtime de Supabase para refrescar la lista en vivo
- Iconos coloreados por tipo (postulación, aprobada, rechazada, tag-match,
  medalla cambiada, recordatorio)
- Badge en vivo en la campana del feed con contador de no leídas
- Marcar leídas individualmente o todas; tap navega al request

### Added — Sprint 9: Cron jobs + pulido
- Cron job diario `fixy-auto-rate` (3am UTC) — auto-asigna 3★ tras 7 días
- Cron job diario `fixy-deadline-reminders` (9am UTC) — recordatorio 24h
- Widgets reutilizables `EmptyState` y `ErrorRetry` (con modo `inline`)
- Empty/error states pulidos en feed, my_requests, ranking, notifications

### Added — Sprint 10: Final + branding
- **Logo y branding**: integración del logo wordmark Fixy en LoginPage,
  configuración de `flutter_launcher_icons` con la mascota Fixo y fondo brand
- **Colores brand consistentes**: `pointsPositive`, `pointsNegative`, `warning`
  + `statusOpen/Approved/Rejected/Completed/Pending` semánticos
- **Perfil público** de cualquier usuario (RF-U04): pantalla read-only con
  hero, medalla, stats, especialidades, links externos, calificaciones
- **Borrar / cancelar**:
  - Cancelar mi solicitud creada (status → cancelada) si está abierta o en revisión
  - Eliminar mi solicitud creada (DELETE) si nunca tuvo postulantes
  - Retirar mi postulación (DELETE) si está pendiente
  - Confirmaciones con `AlertDialog` antes de cualquier acción destructiva
  - Menús accesibles desde Mis Solicitudes y RequestDetailPage
- **README profesional** con badges, tabla de contenidos, capturas y guía completa

### Fixed
- Trigger `notify_tag_match` faltaba cast a `notification_type`
- Trigger `notify_application_status_change` faltaba `related_request_id` en VALUES
- Funciones de trigger marcadas `SECURITY DEFINER` para que puedan escribir
  en notifications, point_log y profiles bajo RLS
- `EmptyState` con modo `inline` para usar dentro de un ListView padre
  (corrige el empty state de Ranking y Recomendados)

### Changed
- `themeMode: ThemeMode.dark` → `ThemeMode.system` (respeta dispositivo)
- `android:label "fixy"` → `"Fixy"` (mayúscula)
- iOS `CFBundleName` `fixy` → `Fixy`
- SQL consolidado: eliminados archivos `fix_*.sql`, todos los arreglos
  ya viven en `01-07_*.sql` para que una instalación nueva sea limpia

### Technical
- ~9000 líneas de código Dart en 80+ archivos
- 7 archivos SQL idempotentes con extensiones (`uuid-ossp`, `pgcrypto`, `pg_cron`)
- 10 tablas Postgres con RLS habilitado y políticas semánticas
- 13 triggers automáticos que mantienen reputación, notificaciones y estado
