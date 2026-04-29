// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestCreator _$RequestCreatorFromJson(Map<String, dynamic> json) =>
    _RequestCreator(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      medal: $enumDecodeNullable(_$MedalEnumMap, json['medal']) ?? Medal.hierro,
    );

Map<String, dynamic> _$RequestCreatorToJson(_RequestCreator instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'medal': _$MedalEnumMap[instance.medal]!,
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

_RequestSummary _$RequestSummaryFromJson(Map<String, dynamic> json) =>
    _RequestSummary(
      id: json['id'] as String,
      type: $enumDecode(_$RequestTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      difficultyLevel: (json['difficulty_level'] as num).toInt(),
      basePoints: (json['base_points'] as num).toInt(),
      economicBenefit: json['economic_benefit'] as num?,
      participantsNeeded: (json['participants_needed'] as num?)?.toInt() ?? 1,
      status:
          $enumDecodeNullable(_$RequestStatusEnumMap, json['status']) ??
          RequestStatus.abierta,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      publishedAt: DateTime.parse(json['published_at'] as String),
      creator: RequestCreator.fromJson(json['creator'] as Map<String, dynamic>),
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Tag>[],
      applicationsCount: (json['applications_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RequestSummaryToJson(_RequestSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$RequestTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'difficulty_level': instance.difficultyLevel,
      'base_points': instance.basePoints,
      'economic_benefit': instance.economicBenefit,
      'participants_needed': instance.participantsNeeded,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'deadline': instance.deadline?.toIso8601String(),
      'published_at': instance.publishedAt.toIso8601String(),
      'creator': instance.creator.toJson(),
      'tags': instance.tags.map((e) => e.toJson()).toList(),
      'applications_count': instance.applicationsCount,
    };

const _$RequestTypeEnumMap = {
  RequestType.asesoria: 'asesoria',
  RequestType.proyecto: 'proyecto',
};

const _$RequestStatusEnumMap = {
  RequestStatus.abierta: 'abierta',
  RequestStatus.enRevision: 'enRevision',
  RequestStatus.enProceso: 'enProceso',
  RequestStatus.completada: 'completada',
  RequestStatus.cancelada: 'cancelada',
};
