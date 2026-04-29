// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApplicationSummary _$ApplicationSummaryFromJson(Map<String, dynamic> json) =>
    _ApplicationSummary(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      applicantId: json['applicant_id'] as String,
      message: json['message'] as String?,
      status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
      appliedAt: DateTime.parse(json['applied_at'] as String),
      request: RequestSummary.fromJson(json['request'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationSummaryToJson(_ApplicationSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_id': instance.requestId,
      'applicant_id': instance.applicantId,
      'message': instance.message,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'applied_at': instance.appliedAt.toIso8601String(),
      'request': instance.request.toJson(),
    };

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.pendiente: 'pendiente',
  ApplicationStatus.aprobada: 'aprobada',
  ApplicationStatus.rechazada: 'rechazada',
};
