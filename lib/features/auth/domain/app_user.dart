import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/reputation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// Espejo de la tabla public.profiles.
/// El field_rename: snake esta configurado globalmente en build.yaml
/// (convierte fullName -> full_name automaticamente al serializar JSON).
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String email,
    required String fullName,
    String? career,
    int? cycle,
    String? bio,
    String? avatarUrl,
    String? whatsappNumber,
    String? portfolioUrl,
    String? linkedinUrl,
    @Default(0) int totalPoints,
    @Default(Medal.hierro) Medal medal,
    @Default(0) num avgRating,
    @Default(0) int ratingsCount,
    @Default(true) bool isActive,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
