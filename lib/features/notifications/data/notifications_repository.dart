import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/models/app_notification.dart';

class NotificationsRepository {
  NotificationsRepository(this._client);
  final SupabaseClient _client;

  /// Lista todas las notificaciones del usuario actual (mas nuevas primero).
  Future<List<AppNotification>> fetchAll(String userId) async {
    final rows = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);
    return rows.map(_map).toList();
  }

  /// Stream realtime de notificaciones del usuario.
  Stream<List<AppNotification>> watch(String userId) {
    return _client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50)
        .map((rows) => rows.map(_map).toList());
  }

  Future<void> markRead(String id) async {
    await _client
        .from('notifications')
        .update({'is_read': true}).eq('id', id);
  }

  Future<void> markAllRead(String userId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }

  AppNotification _map(Map<String, dynamic> row) {
    return AppNotification(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      type: notificationTypeFromDb(row['type'] as String?),
      title: row['title'] as String,
      body: row['body'] as String?,
      relatedRequestId: row['related_request_id'] as String?,
      relatedUserId: row['related_user_id'] as String?,
      isRead: row['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
