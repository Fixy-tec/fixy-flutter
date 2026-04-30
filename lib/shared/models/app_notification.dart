import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

/// Tipos de notificacion (reflejo del enum notification_type en Postgres).
enum NotificationType {
  newApplication,
  applicationApproved,
  applicationRejected,
  requestCompleted,
  tagMatch,
  deadlineReminder,
  medalChanged,
  unknown,
}

NotificationType notificationTypeFromDb(String? raw) => switch (raw) {
      'new_application' => NotificationType.newApplication,
      'application_approved' => NotificationType.applicationApproved,
      'application_rejected' => NotificationType.applicationRejected,
      'request_completed' => NotificationType.requestCompleted,
      'tag_match' => NotificationType.tagMatch,
      'deadline_reminder' => NotificationType.deadlineReminder,
      'medal_changed' => NotificationType.medalChanged,
      _ => NotificationType.unknown,
    };

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String userId,
    required NotificationType type,
    required String title,
    String? body,
    String? relatedRequestId,
    String? relatedUserId,
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
