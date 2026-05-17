// ignore_for_file: avoid_print
/// Stress test contra los endpoints publicos de Supabase.
///
/// Ejecuta N peticiones HTTP concurrentes a 3 escenarios:
///   1. GET /rest/v1/tags        (lectura de catalogo)
///   2. GET /rest/v1/requests    (lectura del feed con joins)
///   3. GET /rest/v1/profiles    (lectura de ranking)
///
/// Mide latencia media, p50, p95, p99 y porcentaje de errores. Imprime un
/// resumen en consola que puede pegarse en la documentacion.
///
/// Uso:
///   dart run tool/stress_test.dart [--n 100] [--scenarios all|tags|feed|profiles]
///
/// Requisitos:
///   - El archivo .env debe tener SUPABASE_URL y SUPABASE_ANON_KEY.
///   - El paquete http esta en pubspec.yaml (lo trae supabase_flutter).
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const _defaultN = 100;

class _Scenario {
  const _Scenario(this.name, this.path);
  final String name;
  final String path;
}

const _scenarios = <_Scenario>[
  _Scenario('tags (catalogo)', '/rest/v1/tags?select=id,name,slug'),
  _Scenario(
    'feed (requests + creator + tags)',
    '/rest/v1/requests?select=id,title,type,'
        'creator:profiles!requests_creator_id_fkey(id,full_name,medal),'
        'request_tags(tag:tags(id,name))'
        '&status=eq.abierta&limit=20',
  ),
  _Scenario(
    'profiles (top ranking)',
    '/rest/v1/profiles?select=id,full_name,total_points,medal'
        '&order=total_points.desc&limit=50',
  ),
];

Future<void> main(List<String> args) async {
  // Parse args
  var n = _defaultN;
  var which = 'all';
  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--n' && i + 1 < args.length) {
      n = int.tryParse(args[i + 1]) ?? _defaultN;
    } else if (args[i] == '--scenarios' && i + 1 < args.length) {
      which = args[i + 1];
    }
  }

  // Cargar .env
  final env = _loadEnv();
  final url = env['SUPABASE_URL'];
  final key = env['SUPABASE_ANON_KEY'];
  if (url == null || key == null || url.contains('YOUR_')) {
    stderr.writeln(
      'ERROR: .env debe contener SUPABASE_URL y SUPABASE_ANON_KEY validos',
    );
    exit(1);
  }

  print('================================================================');
  print('Fixy - Stress test contra Supabase');
  print('Concurrencia: $n peticiones simultaneas por escenario');
  print('Fecha: ${DateTime.now().toIso8601String()}');
  print('Endpoint: $url');
  print('================================================================');

  final results = <_Result>[];

  for (final s in _scenarios) {
    if (which != 'all' && which != s.name.split(' ').first) continue;
    print('\n>>> Escenario: ${s.name}');
    final r = await _runScenario(url, key, s, n);
    results.add(r);
    _printResult(r);
  }

  // Resumen
  print('\n================================================================');
  print('Resumen comparativo');
  print('================================================================');
  print(
    '${'Escenario'.padRight(36)}${'OK'.padLeft(6)}${'KO'.padLeft(6)}'
    '${'Media'.padLeft(10)}${'p50'.padLeft(8)}${'p95'.padLeft(8)}${'p99'.padLeft(8)}',
  );
  for (final r in results) {
    print(
      '${r.name.padRight(36)}'
      '${r.ok.toString().padLeft(6)}'
      '${r.ko.toString().padLeft(6)}'
      '${'${r.meanMs}ms'.padLeft(10)}'
      '${'${r.p50}ms'.padLeft(8)}'
      '${'${r.p95}ms'.padLeft(8)}'
      '${'${r.p99}ms'.padLeft(8)}',
    );
  }
  print('================================================================');
}

class _Result {
  _Result(this.name);
  final String name;
  int ok = 0;
  int ko = 0;
  List<int> latencies = [];
  int meanMs = 0;
  int p50 = 0;
  int p95 = 0;
  int p99 = 0;
  int min = 0;
  int max = 0;
}

Future<_Result> _runScenario(
  String url,
  String key,
  _Scenario s,
  int n,
) async {
  final result = _Result(s.name);
  final client = http.Client();
  try {
    final start = DateTime.now();
    final futures = <Future<int>>[];
    for (var i = 0; i < n; i++) {
      futures.add(_oneRequest(client, '$url${s.path}', key));
    }
    final times = await Future.wait(futures);
    final totalElapsed = DateTime.now().difference(start).inMilliseconds;

    for (final t in times) {
      if (t < 0) {
        result.ko++;
      } else {
        result.ok++;
        result.latencies.add(t);
      }
    }

    if (result.latencies.isNotEmpty) {
      result.latencies.sort();
      result.min = result.latencies.first;
      result.max = result.latencies.last;
      result.meanMs =
          (result.latencies.reduce((a, b) => a + b) / result.latencies.length)
              .round();
      result.p50 = result.latencies[(result.latencies.length * 0.50).floor()];
      result.p95 = result.latencies[(result.latencies.length * 0.95).floor()];
      result.p99 = result.latencies[(result.latencies.length * 0.99).floor()];
    }

    print('  Tiempo total wall-clock: ${totalElapsed}ms');
  } finally {
    client.close();
  }
  return result;
}

Future<int> _oneRequest(http.Client client, String url, String key) async {
  final sw = Stopwatch()..start();
  try {
    final resp = await client.get(
      Uri.parse(url),
      headers: {
        'apikey': key,
        'Authorization': 'Bearer $key',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 15));
    sw.stop();
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return sw.elapsedMilliseconds;
    } else {
      stderr.writeln('  HTTP ${resp.statusCode}: ${resp.body.substring(0, resp.body.length.clamp(0, 120))}');
      return -1;
    }
  } catch (e) {
    sw.stop();
    stderr.writeln('  Error: $e');
    return -1;
  }
}

void _printResult(_Result r) {
  print('  Exitosas:        ${r.ok}');
  print('  Errores:         ${r.ko}');
  if (r.latencies.isNotEmpty) {
    print('  Min:             ${r.min} ms');
    print('  Media:           ${r.meanMs} ms');
    print('  p50:             ${r.p50} ms');
    print('  p95:             ${r.p95} ms');
    print('  p99:             ${r.p99} ms');
    print('  Max:             ${r.max} ms');
  }
}

Map<String, String> _loadEnv() {
  final file = File('.env');
  if (!file.existsSync()) {
    stderr.writeln('ERROR: archivo .env no existe en la raiz del proyecto');
    exit(1);
  }
  final map = <String, String>{};
  for (final line in file.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final eq = trimmed.indexOf('=');
    if (eq < 0) continue;
    final k = trimmed.substring(0, eq).trim();
    final v = trimmed.substring(eq + 1).trim();
    map[k] = v;
  }
  return map;
}

// Para usar este JSON decoder si lo necesitamos en el futuro.
// ignore: unused_element
dynamic _decode(String s) => jsonDecode(s);
