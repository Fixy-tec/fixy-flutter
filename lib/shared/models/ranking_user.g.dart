// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RankingUser _$RankingUserFromJson(Map<String, dynamic> json) => _RankingUser(
  rank: (json['rank'] as num).toInt(),
  id: json['id'] as String,
  fullName: json['full_name'] as String,
  avatarUrl: json['avatar_url'] as String?,
  totalPoints: (json['total_points'] as num).toInt(),
  medal: $enumDecodeNullable(_$MedalEnumMap, json['medal']) ?? Medal.hierro,
);

Map<String, dynamic> _$RankingUserToJson(_RankingUser instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'id': instance.id,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'total_points': instance.totalPoints,
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
