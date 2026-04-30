import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/time_ago.dart';
import '../../../../shared/models/app_notification.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/notifications_providers.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          if (async.value?.any((n) => !n.isRead) ?? false)
            IconButton(
              tooltip: 'Marcar todas como leidas',
              icon: const Icon(Icons.done_all),
              onPressed: () async {
                final uid = ref.read(currentSessionProvider)?.user.id;
                if (uid != null) {
                  await ref
                      .read(notificationsRepositoryProvider)
                      .markAllRead(uid);
                }
              },
            ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => ErrorRetry(error: e),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_none,
              title: 'Sin notificaciones',
              subtitle: 'Te avisaremos cuando ocurra algo relevante.',
            );
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (context, i) => const Divider(height: 1),
            itemBuilder: (context, i) =>
                _NotificationTile(notification: items[i]),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});
  final AppNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final (icon, color) = _iconForType(notification.type, scheme);

    return ListTile(
      tileColor: notification.isRead ? null : scheme.surfaceContainerHighest,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.18),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notification.body != null) Text(notification.body!),
          const SizedBox(height: 2),
          Text(
            timeAgo(notification.createdAt),
            style: TextStyle(
              fontSize: 11,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      onTap: () async {
        if (!notification.isRead) {
          await ref
              .read(notificationsRepositoryProvider)
              .markRead(notification.id);
        }
        if (notification.relatedRequestId != null && context.mounted) {
          context.push('/requests/${notification.relatedRequestId}');
        }
      },
    );
  }

  (IconData, Color) _iconForType(NotificationType t, ColorScheme scheme) {
    return switch (t) {
      NotificationType.newApplication => (Icons.person_add, scheme.primary),
      NotificationType.applicationApproved => (
          Icons.check_circle,
          const Color(0xFF2E7D32)
        ),
      NotificationType.applicationRejected => (
          Icons.cancel,
          const Color(0xFFC62828)
        ),
      NotificationType.requestCompleted => (Icons.task_alt, scheme.primary),
      NotificationType.tagMatch => (Icons.local_offer_outlined, scheme.secondary),
      NotificationType.deadlineReminder => (
          Icons.access_time,
          const Color(0xFFE6B800)
        ),
      NotificationType.medalChanged => (
          Icons.workspace_premium,
          const Color(0xFFE6B800)
        ),
      NotificationType.unknown => (Icons.notifications, scheme.onSurfaceVariant),
    };
  }
}
