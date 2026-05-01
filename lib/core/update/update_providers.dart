import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'update_checker.dart';
import 'update_info.dart';

/// UpdateChecker apuntando al repo publico de Fixy.
final updateCheckerProvider = Provider<UpdateChecker>((ref) {
  return UpdateChecker(
    repoOwner: 'Fixy-tec',
    repoName: 'fixy-flutter',
  );
});

/// Verifica una sola vez al arrancar si hay nueva version.
/// Se ejecuta en background; el banner solo aparece si hay update.
final availableUpdateProvider = FutureProvider<UpdateInfo?>((ref) async {
  return ref.watch(updateCheckerProvider).check();
});
