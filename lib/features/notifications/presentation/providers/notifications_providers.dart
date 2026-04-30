import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../../../shared/models/app_notification.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/notifications_repository.dart';

final notificationsRepositoryProvider =
    Provider<NotificationsRepository>((ref) {
  return NotificationsRepository(supabase);
});

/// Stream realtime de notificaciones del usuario actual.
final notificationsStreamProvider =
    StreamProvider<List<AppNotification>>((ref) {
  final uid = ref.watch(currentSessionProvider)?.user.id;
  if (uid == null) return const Stream.empty();
  return ref.watch(notificationsRepositoryProvider).watch(uid);
});

/// Cantidad de notificaciones no leidas.
final unreadNotificationsCountProvider = Provider<int>((ref) {
  final async = ref.watch(notificationsStreamProvider);
  return async.value?.where((n) => !n.isRead).length ?? 0;
});
