<div align="center">

<img src="assets/logo.png" alt="Fixy logo" width="220"/>

# Fixy

**Asesorías y proyectos para estudiantes Tecsup.**

Plataforma móvil que conecta estudiantes para resolver necesidades académicas mediante asesorías y colaboración en proyectos, con un sistema de reputación gamificado por puntos y medallas.

[![Flutter](https://img.shields.io/badge/Flutter-3.41+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Postgres%20%2B%20Auth-3ECF8E?logo=supabase)](https://supabase.com)
[![Material 3](https://img.shields.io/badge/UI-Material%203-blue)](https://m3.material.io)
[![Tests](https://img.shields.io/badge/tests-41%20passed-brightgreen)](#-pruebas)
[![License](https://img.shields.io/badge/license-Educational-lightgrey)]()
[![Release](https://img.shields.io/badge/release-v1.1.5-1A4CA3)](https://github.com/Fixy-tec/fixy-flutter/releases)

</div>

---

## 📑 Tabla de contenidos

- [Acerca del proyecto](#-acerca-del-proyecto)
- [Características](#-características)
- [Stack tecnológico](#-stack-tecnológico)
- [Sistema de reputación](#-sistema-de-reputación)
- [Quick start](#-quick-start)
- [Estructura del proyecto](#-estructura-del-proyecto)
- [Pruebas](#-pruebas)
- [Auto-actualización](#-auto-actualización)
- [Branding](#-branding)
- [Roadmap](#-roadmap)
- [Licencia](#-licencia)

---

## 🎯 Acerca del proyecto

**Fixy** es una app móvil multiplataforma (Android + iOS) desarrollada como proyecto final del curso **Aplicaciones Móviles Multiplataforma — Tecsup 2026-1**. Permite a estudiantes de Tecsup publicar dos tipos de solicitudes:

- 🎓 **Asesorías** — buscar a alguien que ayude con un curso, tema o proyecto.
- 🤝 **Proyectos** — buscar socios para desarrollar algo en conjunto.

Otros estudiantes pueden postular, el creador selecciona, se desbloquea el contacto por WhatsApp y al finalizar ambas partes se califican mutuamente, ganando puntos para subir de medalla al estilo *League of Legends*.

---

## ✨ Características

### Autenticación
- Registro multi-step de **5 pasos** con email institucional `@tecsup.edu.pe`
- Validación en 3 capas: cliente, CHECK constraint y trigger SQL
- Persistencia de sesión vía Supabase Auth con flow PKCE

### Solicitudes
- Feed (Dashboard) con welcome card, actividad reciente y noticias
- Tab **Buscar** dedicada con chips horizontales (Todo / Asesorías / Proyectos / Recomendados) y filtros expandibles (compensación, dificultad, tags)
- Creación multi-step en **3 pasos** con resumen en vivo
- **Cancelar** o **eliminar** solicitudes propias antes de tener postulantes

### Postulaciones
- Postularse con mensaje de presentación (300 chars)
- Aprobar / rechazar / **retirar** postulación
- Una sola postulación aprobada por solicitud (validado en trigger SQL)

### WhatsApp
- Al aprobar postulante, se desbloquea el número del otro
- Botón "Abrir WhatsApp" usa `wa.me/` con `url_launcher`

### Calificaciones
- Modal con 5 estrellas y comentario opcional (200 chars)
- Modificadores en vivo: **5★ ×1.5** · **4★ ×1.2** · **3★ base** · **2★ −30** · **1★ −80**
- Trigger SQL aplica los puntos automáticamente y dispara cambio de medalla

### Perfil
- 6 **avatares Fixo** (artista, cyborg, hacker, karateka, emprendedor, pirata)
- Propio editable: bio, carrera, ciclo, portfolio, LinkedIn, GitHub, WhatsApp, especialidades
- Público de cualquier usuario (read-only) con todos sus stats
- Progreso visual a la siguiente medalla

### Ranking
- Tabla de líderes con card "Tu rango actual" + medalla circular grande
- Row horizontal con todas las medallas (Hierro→Challenger)
- Filtro por medalla
- Podio con colores oro/plata/bronce para top 3

### Notificaciones
- In-app con **realtime de Supabase** (badge en vivo en la campana del Dashboard)
- 7 tipos: nueva postulación, aprobada, rechazada, completada, tag-match, recordatorio, cambio de medalla
- Marcar leídas individualmente o todas; tap navega al request relacionado

### Auto-actualización
- Banner integrado en el Dashboard cuando hay nueva versión en GitHub Releases
- Pantalla full-screen de descarga con barra de progreso
- Sin necesidad de Play Store

### Cron jobs (pg_cron)
- **Auto-rating de 3★** tras 7 días sin calificar
- **Recordatorio de fecha límite** 24h antes

### Calidad
- **41 pruebas unitarias** (validators, reputación, comparación de versiones, formato de tiempo)
- **Vista 404** integrada en `go_router.errorBuilder`
- **Stress test** propio en `tool/stress_test.dart` (300 req, 0 errores en benchmarks)
- `flutter analyze`: 0 errores en todas las versiones publicadas

---

## 🛠 Stack tecnológico

| Capa | Tecnología |
|---|---|
| **UI Framework** | Flutter 3.41 / Dart 3.11 con Material 3 |
| **Backend** | Supabase (Auth + Postgres + Realtime + RLS + pg_cron) |
| **State management** | flutter_riverpod 2.x |
| **Routing** | go_router 14.x con `StatefulShellRoute` (5 tabs + errorBuilder) |
| **Modelos** | freezed 3.x + json_serializable (codegen) |
| **HTTP/SDK** | supabase_flutter (cliente oficial) |
| **Auto-updater** | package_info_plus + dio + open_filex + path_provider |
| **Firma APK** | Keystore propia (upload-keystore.jks) |
| **Tipografía** | Google Fonts (Inter) |
| **Localización** | intl con locale español |
| **Otros** | url_launcher, flutter_dotenv, flutter_launcher_icons |

> **Decisión de diseño**: la lógica crítica de reputación (cálculo de puntos, cambio de medalla, auto-rating, validaciones de negocio) vive en **triggers SQL con `SECURITY DEFINER`**, no en Dart. Esto evita que un cliente malicioso manipule la reputación.

---

## 🏆 Sistema de reputación

### Puntos base por dificultad

| Dificultad | Puntos base |
|:-:|:-:|
| 1 | +50 |
| 2 | +100 |
| 3 | +180 |
| 4 | +280 |
| 5 | +400 |

### Modificadores por calificación recibida

| ⭐ | Efecto |
|:-:|---|
| 5 | ×1.5 (bonus +50%) |
| 4 | ×1.2 (bonus +20%) |
| 3 | ×1.0 (base) |
| 2 | −30 pts fijos |
| 1 | −80 pts fijos |

### Medallas

| Medalla | Rango |
|---|---|
| Hierro | 0 – 299 |
| Bronce | 300 – 799 |
| Plata | 800 – 1799 |
| Oro | 1800 – 3499 |
| Diamante | 3500 – 5999 |
| Maestro | 6000 – 9999 |
| Challenger | 10000+ |

> Las medallas pueden **bajar** si el usuario acumula penalizaciones, igual que en LoL/Valorant.

---

## 🚀 Quick start

### Prerrequisitos

- Flutter 3.41+
- Dart 3.11+
- Cuenta gratis en [supabase.com](https://supabase.com)
- Android Studio o VS Code con extensión Flutter

### 1. Clonar e instalar

```bash
git clone https://github.com/Fixy-tec/fixy-flutter.git
cd fixy-flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 2. Configurar Supabase

1. Crea un proyecto en [supabase.com](https://supabase.com).
2. **SQL Editor** → ejecuta los 8 archivos de [`supabase/migrations/`](supabase/migrations/) en orden.
3. **Authentication → Providers → Email**: enable, desactivar "Confirm email" para desarrollo.
4. **Database → Extensions**: habilitar `pg_cron`.
5. **Database → Replication**: habilitar Realtime en `notifications`, `applications`, `requests`.

> Detalles paso a paso en [`supabase/README.md`](supabase/README.md).

### 3. Configurar variables de entorno

```bash
cp .env.example .env
```

Reemplaza con los valores de **Project Settings → API** en Supabase:

```env
SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGc...
```

### 4. Correr la app

```bash
flutter run
```

### 5. Compilar APK release (opcional)

Necesitas generar tu propia keystore primero:

```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Luego crea `android/key.properties`:

```
storePassword=<tu password>
keyPassword=<tu password>
keyAlias=upload
storeFile=upload-keystore.jks
```

Y compila:

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

#### Usuarios demo

Si aplicaste `06_seed_demo.sql`, puedes iniciar sesión con:

| Email | Contraseña | Medalla |
|---|---|---|
| `sofia.rios@tecsup.edu.pe` | `fixy12345` | Diamante |
| `ana.castillo@tecsup.edu.pe` | `fixy12345` | Maestro |
| `marco.villanueva@tecsup.edu.pe` | `fixy12345` | Diamante |
| `luis.mendoza@tecsup.edu.pe` | `fixy12345` | Plata |
| `jorge.paredes@tecsup.edu.pe` | `fixy12345` | Bronce |

---

## 📂 Estructura del proyecto

```
fixy-flutter/
├── lib/
│   ├── core/
│   │   ├── theme/        # AppColors + AppTheme M3
│   │   ├── router/       # go_router + AppShell + 404
│   │   ├── supabase/     # cliente singleton
│   │   ├── constants/    # reputation.dart + avatars.dart
│   │   ├── update/       # auto-updater (UpdateChecker, UpdateBanner)
│   │   └── utils/        # validators, time_ago, whatsapp_launcher
│   ├── features/
│   │   ├── auth/         # login, registro multi-step, sesión
│   │   ├── dashboard/    # Inicio con welcome + actividad reciente
│   │   ├── feed/         # repositorio legacy del feed
│   │   ├── search/       # tab Buscar con filtros
│   │   ├── requests/     # crear (3 pasos) + mis solicitudes (4 tabs)
│   │   ├── applications/ # detalle + postular + aprobar
│   │   ├── ratings/      # calificaciones (5 estrellas)
│   │   ├── profile/      # propio editable + público read-only
│   │   ├── ranking/      # tabla con filtro por medalla
│   │   ├── notifications/# stream realtime
│   │   └── error/        # NotFoundPage (404)
│   ├── shared/
│   │   ├── widgets/      # UserAvatar, MedalImage, RequestCard, EmptyState
│   │   └── models/       # entidades freezed compartidas
│   ├── app.dart
│   └── main.dart
├── test/                 # 41 pruebas unitarias
│   └── core/
│       ├── utils/        # validators_test, time_ago_test
│       ├── constants/    # reputation_test
│       └── update/       # update_info_test
├── tool/
│   └── stress_test.dart  # benchmark contra Supabase
├── supabase/
│   ├── migrations/       # 8 SQL files (idempotentes)
│   └── README.md
├── assets/
│   ├── logo.png
│   ├── icon_foreground.png
│   ├── avatars/          # 6 PNGs (Fixo en distintos roles)
│   └── medals/           # 7 PNGs (Hierro→Challenger)
├── android/ ios/
└── pubspec.yaml
```

---

## 🧪 Pruebas

### Pruebas unitarias (41 tests)

```bash
flutter test
```

Cubren:

- **validators**: email Tecsup, contraseña mínima, campos requeridos (15 tests)
- **reputación**: asignación de medallas por puntos, basePointsByLevel, consistencia del ladder (12 tests)
- **update_info**: comparación semver con prefijos `v` y sufijos `+N`/`-beta` (9 tests)
- **time_ago**: formato relativo en español (8 tests)

### Stress test

```bash
dart run tool/stress_test.dart --n 100
```

Ejecuta 100 peticiones concurrentes contra los endpoints reales de Supabase en 3 escenarios. Resultados en [`docs/STRESS_TEST_RESULTS.md`](docs/STRESS_TEST_RESULTS.md).

### Análisis estático

```bash
flutter analyze
```

0 errores y 0 warnings en todas las versiones publicadas (v1.0.0 a v1.1.5).

---

## 🔄 Auto-actualización

La app **no necesita Play Store** para distribuir nuevas versiones. Cuando publiques una release en GitHub con un APK adjunto, los usuarios con la app instalada verán automáticamente:

1. Banner azul en el Dashboard: *"Nueva versión v1.1.X disponible"*
2. Tap → diálogo con release notes
3. Tap **Descargar** → pantalla full-screen con barra de progreso
4. Al terminar → Android pide confirmar instalación
5. App actualizada sin perder sesión ni datos locales

Workflow para sacar una nueva release:

```bash
# 1. Bumpear version en pubspec.yaml
# 2. Build APK firmado
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk build/Fixy-X.Y.Z.apk

# 3. Tag + push
git tag -a vX.Y.Z -m "vX.Y.Z - descripción"
git push origin vX.Y.Z

# 4. En GitHub web: New Release con el tag, adjuntar el APK
```

---

## 🎨 Branding

### Paleta

| Color | Hex | Uso |
|---|---|---|
| 🔵 Primary | `#1A4CA3` | Branding, botones primarios, "Abierta" |
| 🟢 Secondary | `#057F78` | Acentos, "En proceso" |
| 🟢 Points positive | `#34A29B` | Puntos ganados, montos S/ |
| 🔴 Points negative | `#D64545` | Puntos perdidos, "Rechazado" |
| 🟡 Warning | `#E6B800` | "Pendiente", recordatorios |

Toda la UI usa `ColorScheme.fromSeed(#1A4CA3)` para cohesión Material 3 en modo claro y oscuro (respeta el ajuste del dispositivo).

### Logo y mascota

- **Logo**: birrete de graduación con flecha hacia arriba (símbolo de progreso académico), en gradiente brand.
- **Mascota Fixo**: robot estudiante usado como icono del launcher (fondo `#1A4CA3`) y como avatares de perfil en 6 variantes.

---

## 🛣 Roadmap

Implementado hasta v1.1.5:

- [x] Autenticación con email Tecsup
- [x] Registro multi-step + selección de avatar
- [x] Dashboard con welcome y actividad reciente
- [x] Tab Buscar dedicada con filtros
- [x] Crear / cancelar / eliminar solicitudes
- [x] Postulaciones con aprobar / rechazar / retirar
- [x] WhatsApp deeplink
- [x] Sistema de calificaciones mutuas
- [x] Medallas Hierro → Challenger con cambios automáticos
- [x] Ranking con filtro por medalla
- [x] Perfil propio + público
- [x] Notificaciones in-app realtime
- [x] Cron jobs (auto-rating + deadline reminders)
- [x] Auto-updater desde GitHub Releases
- [x] Vista 404
- [x] 41 pruebas unitarias
- [x] Stress test propio

Backlog para futuras versiones:

- [ ] Sistema de pagos integrado (Yape/Plin/Stripe)
- [ ] Multi-institución (UCSM, UCSP, UNSA)
- [ ] Verificación de identidad con carnet
- [ ] Reportes de usuarios + moderación
- [ ] Insignias por logros (no solo medallas por puntos)
- [ ] Notificaciones push (FCM)

---

## 📜 Licencia

Proyecto académico para Tecsup 2026-1. Uso educativo.

---

<div align="center">

Hecho con 💙 en Arequipa, Perú

</div>
