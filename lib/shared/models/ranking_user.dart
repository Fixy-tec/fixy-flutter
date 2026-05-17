import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/reputation.dart';

part 'ranking_user.freezed.dart';
part 'ranking_user.g.dart';

@freezed
abstract class RankingUser with _$RankingUser {
  const factory RankingUser({
    required int rank,
    required String id,
    required String fullName,
    String? avatarUrl,
    String? avatarSlug,
    required int totalPoints,
    @Default(Medal.hierro) Medal medal,
  }) = _RankingUser;

  factory RankingUser.fromJson(Map<String, dynamic> json) =>
      _$RankingUserFromJson(json);
}
