// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApplicantInfo _$ApplicantInfoFromJson(Map<String, dynamic> json) =>
    _ApplicantInfo(
      applicationId: json['application_id'] as String,
      applicantId: json['applicant_id'] as String,
      fullName: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      medal: $enumDecodeNullable(_$MedalEnumMap, json['medal']) ?? Medal.hierro,
      avgRating: json['avg_rating'] as num? ?? 0,
      ratingsCount: (json['ratings_count'] as num?)?.toInt() ?? 0,
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
      message: json['message'] as String?,
      status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
      whatsappNumber: json['whatsapp_number'] as String?,
      appliedAt: DateTime.parse(json['applied_at'] as String),
    );

Map<String, dynamic> _$ApplicantInfoToJson(_ApplicantInfo instance) =>
    <String, dynamic>{
      'application_id': instance.applicationId,
      'applicant_id': instance.applicantId,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'medal': _$MedalEnumMap[instance.medal]!,
      'avg_rating': instance.avgRating,
      'ratings_count': instance.ratingsCount,
      'total_points': instance.totalPoints,
      'message': instance.message,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'whatsapp_number': instance.whatsappNumber,
      'applied_at': instance.appliedAt.toIso8601String(),
    };

const _$MedalEnumMap = {
  Medal.hierro: 'hierro',
  Medal.bronce: 'bronce',
  Medal.plata: 'plata',
  Medal.oro: 'oro',
  Medal.diamante: 'diamante',
  Medal.maestro: 'maestro',
  Medal.challenger: 'challenger',
};

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.pendiente: 'pendiente',
  ApplicationStatus.aprobada: 'aprobada',
  ApplicationStatus.rechazada: 'rechazada',
};
