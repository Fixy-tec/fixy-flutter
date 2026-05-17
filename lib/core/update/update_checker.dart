import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'update_info.dart';

class UpdateChecker {
  UpdateChecker({
    required this.repoOwner,
    required this.repoName,
    Dio? dio,
  }) : _dio = dio ?? Dio();

  final String repoOwner;
  final String repoName;
  final Dio _dio;

  /// Consulta GitHub Releases. Retorna `UpdateInfo` si hay una version
  /// posterior con un APK adjunto, o null si ya estas al dia.
  Future<UpdateInfo?> check() async {
    if (!Platform.isAndroid) return null;
    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version;

      final response = await _dio.get<Map<String, dynamic>>(
        'https://api.github.com/repos/$repoOwner/$repoName/releases/latest',
        options: Options(
          headers: {'Accept': 'application/vnd.github+json'},
        ),
      );
      final data = response.data;
      if (data == null) return null;

      final tag = (data['tag_name'] as String?) ?? '';
      final notes = (data['body'] as String?) ?? '';
      final htmlUrl = (data['html_url'] as String?) ?? '';
      final assets = (data['assets'] as List<dynamic>?) ?? const [];

      final apkAsset = assets.cast<Map<String, dynamic>>().firstWhere(
            (a) => (a['name'] as String? ?? '').toLowerCase().endsWith('.apk'),
            orElse: () => <String, dynamic>{},
          );
      if (apkAsset.isEmpty) return null;

      final apkUrl = apkAsset['browser_download_url'] as String;
      if (!UpdateInfo.isNewerVersion(current, tag)) return null;

      return UpdateInfo(
        currentVersion: current,
        latestVersion: tag,
        apkUrl: apkUrl,
        releaseNotes: notes,
        releaseUrl: htmlUrl,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('UpdateChecker.check error: $e');
      }
      return null;
    }
  }

  /// Descarga el APK y lanza el instalador del sistema.
  /// Tira excepcion con mensaje legible si algo falla (asi el caller
  /// puede mostrar el error en un SnackBar visible).
  Future<void> downloadAndInstall(
    String apkUrl, {
    void Function(double progress)? onProgress,
  }) async {
    // Usar el directorio "external files" de la app que es accesible
    // por el instalador de Android sin FileProvider extra.
    // Fallback a cache directory si no esta disponible.
    Directory dir;
    try {
      final ext = await getExternalStorageDirectory();
      dir = ext ?? await getApplicationCacheDirectory();
    } catch (_) {
      dir = await getApplicationCacheDirectory();
    }

    final filePath = '${dir.path}/Fixy-update.apk';
    final file = File(filePath);

    // Limpia descarga previa para evitar APK corruptos
    if (await file.exists()) {
      try {
        await file.delete();
      } catch (_) {
        // best effort
      }
    }

    try {
      await _dio.download(
        apkUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0 && onProgress != null) {
            onProgress(received / total);
          }
        },
        options: Options(
          followRedirects: true,
          receiveTimeout: const Duration(minutes: 5),
        ),
      );
    } catch (e) {
      throw Exception('No se pudo descargar el APK: $e');
    }

    final result = await OpenFilex.open(filePath);
    if (result.type != ResultType.done) {
      throw Exception(
        'No se pudo abrir el instalador (${result.type.name}): ${result.message}\n'
        'Ruta: $filePath\n\n'
        'Verifica que Fixy tenga permiso para instalar apps desconocidas en:\n'
        'Ajustes -> Apps -> Fixy -> Instalar apps desconocidas',
      );
    }
  }
}
