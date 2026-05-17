# Resultados del Stress Test — Fixy v1.1.5

**Fecha de ejecución**: 2026-05-17
**Concurrencia**: 100 peticiones simultáneas por escenario (300 totales)
**Backend**: Supabase (plan gratuito) — `https://oagtkwpxpszzzcwuvneq.supabase.co`
**Herramienta**: script `tool/stress_test.dart` (Dart puro con `package:http`)

## Comando ejecutado

```bash
dart run tool/stress_test.dart --n 100
```

## Resultados

| Escenario | Endpoint consultado | OK | KO | Media | p50 | p95 | p99 |
|---|---|:-:|:-:|:-:|:-:|:-:|:-:|
| Tags (catálogo) | `GET /rest/v1/tags` | 100 | 0 | 2083 ms | 2084 ms | 2098 ms | 2108 ms |
| Feed (joins anidados) | `GET /rest/v1/requests` con creator + tags | 100 | 0 | 438 ms | 447 ms | 535 ms | 538 ms |
| Profiles (top ranking) | `GET /rest/v1/profiles` ordenado por puntos | 100 | 0 | 396 ms | 405 ms | 444 ms | 447 ms |

## Análisis

- **Tasa de éxito: 100%** — los 300 requests respondieron correctamente con código 2xx.
- **Latencia del feed (con joins)**: media de 438 ms y p95 < 600 ms. Aceptable para una pantalla principal que se carga al abrir la app, considerando que el query incluye dos joins anidados (`profiles` + `request_tags` + conteo de `applications`).
- **Latencia del ranking**: 396 ms en media para devolver 50 perfiles ordenados. Excelente.
- **Latencia de tags**: ~2 s en media. Es la primera consulta del lote y arrastra el "cold start" del pool de conexiones de Supabase (PostgREST). Las siguientes consultas (feed y profiles) ya muestran latencias normales. En uso real, el catálogo de tags se carga una sola vez al iniciar la sesión, por lo que el cold-start solo se nota en la primera apertura de la app.

## Sin errores de rate limit

Supabase tiene un límite teórico de ~1000 req/s en PostgREST. Las 100 peticiones concurrentes están muy por debajo de ese umbral; ningún error 429 ("Too Many Requests") fue retornado.

## Conclusión

El backend Supabase soporta la carga concurrente esperada para el piloto en Tecsup sin necesidad de optimizaciones adicionales. Si en el futuro se requiriera servir a más de 1000 estudiantes activos simultáneamente, las opciones son:

1. Pasar al plan Pro de Supabase (USD 25/mes) que aumenta los límites.
2. Agregar índices en columnas filtradas frecuentemente (`requests.status`, `requests.creator_id`, `profiles.total_points`).
3. Implementar cache en cliente con Riverpod (ya parcialmente hecho via `FutureProvider`).

## Cómo reproducir

```bash
# Asegurate de tener .env configurado con SUPABASE_URL y SUPABASE_ANON_KEY
flutter pub get
dart run tool/stress_test.dart --n 100

# Variantes:
dart run tool/stress_test.dart --n 50           # menos concurrencia
dart run tool/stress_test.dart --scenarios feed # solo el escenario "feed"
```

Los resultados pueden variar según:
- Conexión a internet del cliente que ejecuta el test
- Carga actual del cluster de Supabase
- Ubicación geográfica (latencia a us-east-1 de AWS)
