# Changelog

Todos los cambios notables a este proyecto se documentan aquí.
Sigue el formato de [Keep a Changelog](https://keepachangelog.com/es/1.1.0/).

## [1.1.2] - 2026-05-16

### Fixed
- **Avatares se salian del circulo en editor de perfil**: el `Container`
  redondo no recortaba la imagen child; ahora usa `ClipOval` + `shape: circle`
  con `clipBehavior: antiAlias`.
- **Avatares en step 2 del registro** con el mismo problema: clip aplicado
  + check-circle del seleccionado ahora va sobre fondo blanco para que se
  vea contra el avatar.
- **Ranking mostraba iniciales en vez del avatar elegido**: agregado
  `avatarSlug` al modelo `RankingUser` y al SELECT del repository; el tile
  ahora muestra el avatar Fixo si el usuario eligio uno.

### Added
- **Buscar: chips horizontales** Todo / Asesorias / Proyectos / Recomendados
  arriba de los filtros expandibles, como tenia el feed antiguo.
- "Recomendados" filtra requests cuyos tags coinciden con los del usuario.
- El filtro "TIPO" se removio del panel expandible (ahora vive como chip).

## [1.1.1] - 2026-05-16

### Fixed
- **Auto-updater quedaba en pantalla negra al descargar**: el AlertDialog con
  ValueListenableBuilder no se renderizaba sobre algunos devices y, ademas, si
  `OpenFilex.open()` fallaba la excepcion se ignoraba silenciosamente.
- Reemplazado el dialog por una **pantalla full-screen dedicada** con titulo,
  icono grande, barra de progreso visible (10 px) y texto del porcentaje.
- **Descarga ahora va a directorio externo** (`getExternalStorageDirectory`)
  en vez de cache interno, asi el instalador de Android puede abrir el APK
  sin requerir FileProvider extra.
- `OpenFilex.open()` ahora **tira excepcion explicita** si falla, mostrando
  al usuario la ruta del archivo y un mensaje claro pidiendo activar "Instalar
  apps desconocidas" en Ajustes.
- Pagina de descarga tiene boton **Reintentar** si la descarga o el instalador
  fallan.

## [1.1.0] - 2026-05-04

Rediseno completo de UX alineado al prototipo web del equipo, manteniendo
el stack mobile (Flutter + Supabase). 5 tabs en lugar de 4: Inicio,
Solicitudes, Buscar, Ranking, Perfil.

### Added
- **Registro multi-step (5 pasos)**: cuenta basica → tags → avatar → about → links.
  Solo el primer paso es obligatorio; los demas pueden saltarse y completarse
  desde el perfil. Indicador de progreso visual arriba.
- **6 avatares Fixo** (artista, cyborg, hacker, karateka, emprendedor, pirata)
  como PNGs en `assets/avatars/`. Elegibles en registro y editor de perfil.
- **Crear solicitud multi-step (3 pasos)**: tipo → detalles → condiciones+resumen.
  Cards visuales para tipo, slider con preview en vivo de puntos por dificultad,
  card de resumen al final.
- **7 medallas PNG** (`assets/medals/`) reemplazan el icono escudo generico
  en MedalImage. Usadas en perfil, ranking y top users.
- **Dashboard de Inicio nuevo**: header con logo + campana, welcome card con
  gradiente brand y CTAs Explorar/Crear, card de novedades, actividad reciente
  (ultimas 4 notificaciones), card de comunidad.
- **Tab Buscar dedicada**: header gradient, search bar, filtros expandibles
  (Tipo / Compensacion / Dificultad / Tags), contador de resultados, mismas
  cards que el feed.
- **Perfil rediseñado**: hero con avatar grande + 4 stats compactos (Puntos /
  Ranking / Rating / Completadas) + barra de progreso a la siguiente medalla,
  todo en un solo card. Secciones Sobre mi / Tecnologias / Contacto / Links /
  Ultimas calificaciones, cada una con header en mayusculas estilo etiqueta.
- **Ranking rediseñado**: header gradient, card "Tu rango actual" con medalla
  grande circular y progress overlay, row horizontal con todas las medallas
  ("Tu aqui" en la tuya), filtro horizontal por medalla, top users con icono
  de podio para los 3 primeros + medalla PNG en lugar de chip.
- **Public profile**: usa avatar PNG si el usuario lo eligio, MedalImage,
  link de GitHub si existe.

### Changed
- **Inicio anterior (Feed con filtros)** reemplazado por SearchPage en la
  tab "Buscar"; la tab "Inicio" muestra ahora el Dashboard.
- **Bottom navigation** pasa de 4 a 5 tabs (agrega "Buscar").
- **Editor de perfil** incluye selector de avatar horizontal + campo GitHub.
- **AuthRepository.signUp** acepta avatar, bio, github, linkedin, portfolio,
  tags — todos opcionales.

### Database
- **Migracion 08_avatar.sql**: agrega columnas `avatar_slug` (con check de
  los 6 valores validos) y `github_url` a `profiles`. Idempotente.
- `01_schema.sql` actualizado para que las instalaciones nuevas tengan ambas
  columnas desde el inicio.

### Technical
- Nuevos widgets reusables: `UserAvatar` (con fallback a iniciales) y
  `MedalImage`.
- Nuevo provider `searchFiltersProvider` y `searchResultsProvider` con
  filtrado en cliente.
- Catalogo de avatares en `lib/core/constants/avatars.dart`.

## [1.0.1] - 2026-05-01

### Fixed
- **APK release no podia conectarse a Supabase** — faltaban los permisos
  `INTERNET` y `ACCESS_NETWORK_STATE` en `main/AndroidManifest.xml`
  (Flutter solo los agrega en debug/profile por defecto)

### Added
- **Auto-update desde GitHub Releases**: la app revisa al arrancar si hay
  una version mas nueva en `Fixy-tec/fixy-flutter` releases. Si encuentra
  una con APK adjunto, muestra un banner sobre el feed con CTA "Descargar
  e instalar". Tap descarga el APK con barra de progreso y abre el
  instalador del sistema (el usuario solo confirma).
- Permisos: `REQUEST_INSTALL_PACKAGES` para instalar APKs
- Packages: `package_info_plus`, `dio`, `path_provider`, `open_filex`,
  `permission_handler`
- **APK firmado con keystore propia** (signing config en
  `android/app/build.gradle.kts` lee de `key.properties`, ambos en
  `.gitignore`). Esto permite actualizaciones in-place sin desinstalar y
  da identidad consistente al desarrollador.

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
