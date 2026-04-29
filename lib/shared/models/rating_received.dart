import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/reputation.dart';

part 'rating_received.freezed.dart';
part 'rating_received.g.dart';

@freezed
abstract class RatingReceived with _$RatingReceived {
  const factory RatingReceived({
    required String id,
    required String raterId,
    required String raterFullName,
    @Default(Medal.hierro) Medal raterMedal,
    required int stars,
    String? comment,
    required DateTime createdAt,
  }) = _RatingReceived;

  factory RatingReceived.fromJson(Map<String, dynamic> json) =>
      _$RatingReceivedFromJson(json);
}
