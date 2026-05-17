// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_received.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RatingReceived _$RatingReceivedFromJson(Map<String, dynamic> json) =>
    _RatingReceived(
      id: json['id'] as String,
      raterId: json['rater_id'] as String,
      raterFullName: json['rater_full_name'] as String,
      raterAvatarSlug: json['rater_avatar_slug'] as String?,
      raterMedal:
          $enumDecodeNullable(_$MedalEnumMap, json['rater_medal']) ??
          Medal.hierro,
      stars: (json['stars'] as num).toInt(),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$RatingReceivedToJson(_RatingReceived instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rater_id': instance.raterId,
      'rater_full_name': instance.raterFullName,
      'rater_avatar_slug': instance.raterAvatarSlug,
      'rater_medal': _$MedalEnumMap[instance.raterMedal]!,
      'stars': instance.stars,
      'comment': instance.comment,
      'created_at': instance.createdAt.toIso8601String(),
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
