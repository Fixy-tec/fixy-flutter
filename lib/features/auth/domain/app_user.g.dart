// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['full_name'] as String,
  career: json['career'] as String?,
  cycle: (json['cycle'] as num?)?.toInt(),
  bio: json['bio'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  avatarSlug: json['avatar_slug'] as String?,
  whatsappNumber: json['whatsapp_number'] as String?,
  portfolioUrl: json['portfolio_url'] as String?,
  linkedinUrl: json['linkedin_url'] as String?,
  githubUrl: json['github_url'] as String?,
  totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
  medal: $enumDecodeNullable(_$MedalEnumMap, json['medal']) ?? Medal.hierro,
  avgRating: json['avg_rating'] as num? ?? 0,
  ratingsCount: (json['ratings_count'] as num?)?.toInt() ?? 0,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'full_name': instance.fullName,
  'career': instance.career,
  'cycle': instance.cycle,
  'bio': instance.bio,
  'avatar_url': instance.avatarUrl,
  'avatar_slug': instance.avatarSlug,
  'whatsapp_number': instance.whatsappNumber,
  'portfolio_url': instance.portfolioUrl,
  'linkedin_url': instance.linkedinUrl,
  'github_url': instance.githubUrl,
  'total_points': instance.totalPoints,
  'medal': _$MedalEnumMap[instance.medal]!,
  'avg_rating': instance.avgRating,
  'ratings_count': instance.ratingsCount,
  'is_active': instance.isActive,
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
