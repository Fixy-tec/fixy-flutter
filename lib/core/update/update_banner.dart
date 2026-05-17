import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import 'update_info.dart';
import 'update_providers.dart';

/// Banner que aparece sobre el feed cuando hay una nueva version en GitHub.
/// Tap descarga el APK y lanza el instalador del sistema.
class UpdateBanner extends ConsumerWidget {
  const UpdateBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(availableUpdateProvider);
    final info = async.value;
    if (info == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _onTap(context, ref, info),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              children: [
                const Icon(Icons.system_update,
                    color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nueva version ${info.latestVersion} disponible',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'Toca para descargar e instalar',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.download_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTap(
    BuildContext context,
    WidgetRef ref,
    UpdateInfo info,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Actualizar a ${info.latestVersion}'),
        content: SingleChildScrollView(
          child: Text(
            info.releaseNotes.isEmpty
                ? 'Hay una nueva version disponible. ¿Descargar e instalar?'
                : info.releaseNotes,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Despues'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Descargar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    // Empuja una pantalla full-screen para descargar.
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _DownloadPage(info: info),
      ),
    );
  }
}

/// Pantalla full-screen mientras se descarga el APK. Mucho mas visible que
/// un AlertDialog (que en algunos devices se ve apenas como un cuadrito
/// gris sobre la barrera negra).
class _DownloadPage extends ConsumerStatefulWidget {
  const _DownloadPage({required this.info});
  final UpdateInfo info;

  @override
  ConsumerState<_DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends ConsumerState<_DownloadPage> {
  double _progress = 0;
  String _status = 'Preparando descarga...';
  String? _error;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      setState(() => _status = 'Descargando APK...');
      await ref.read(updateCheckerProvider).downloadAndInstall(
            widget.info.apkUrl,
            onProgress: (p) => setState(() {
              _progress = p;
              _status = 'Descargando APK... ${(p * 100).toStringAsFixed(0)}%';
            }),
          );
      // Si OpenFilex.open funciono, el instalador del SO esta encima.
      // Cerramos la pagina automaticamente.
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizando a ${widget.info.latestVersion}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: _error == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.system_update,
                      size: 80,
                      color: scheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _status,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _progress > 0 ? _progress : null,
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'El APK pesa ~57 MB. Puede tardar 1-2 min en conexiones lentas.',
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Cuando termine la descarga, Android te pedira confirmar la instalacion.',
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: scheme.error),
                    const SizedBox(height: 16),
                    const Text(
                      'No se pudo actualizar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _error!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _error = null;
                          _progress = 0;
                          _status = 'Reintentando...';
                        });
                        _start();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
