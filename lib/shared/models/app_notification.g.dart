// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      body: json['body'] as String?,
      relatedRequestId: json['related_request_id'] as String?,
      relatedUserId: json['related_user_id'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'body': instance.body,
      'related_request_id': instance.relatedRequestId,
      'related_user_id': instance.relatedUserId,
      'is_read': instance.isRead,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.newApplication: 'newApplication',
  NotificationType.applicationApproved: 'applicationApproved',
  NotificationType.applicationRejected: 'applicationRejected',
  NotificationType.requestCompleted: 'requestCompleted',
  NotificationType.tagMatch: 'tagMatch',
  NotificationType.deadlineReminder: 'deadlineReminder',
  NotificationType.medalChanged: 'medalChanged',
  NotificationType.unknown: 'unknown',
};
