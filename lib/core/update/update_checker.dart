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
    if (!Platform.isAndroid) return null; // solo Android puede instalar APKs
    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version; // ej: "1.0.0"

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
        debugPrint('UpdateChecker error: $e');
      }
      return null;
    }
  }

  /// Descarga el APK al directorio de descargas y lanza el instalador.
  /// El usuario tiene que confirmar la instalacion (Android lo exige).
  Future<void> downloadAndInstall(
    String apkUrl, {
    void Function(double progress)? onProgress,
  }) async {
    final dir = await getApplicationCacheDirectory();
    final filePath = '${dir.path}/Fixy-update.apk';
    // Borra version previa si existia
    final existing = File(filePath);
    if (await existing.exists()) {
      await existing.delete();
    }
    await _dio.download(
      apkUrl,
      filePath,
      onReceiveProgress: (received, total) {
        if (total > 0 && onProgress != null) {
          onProgress(received / total);
        }
      },
    );
    await OpenFilex.open(filePath);
  }
}
