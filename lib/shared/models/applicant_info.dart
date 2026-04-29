import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/reputation.dart';
import 'application_summary.dart';

part 'applicant_info.freezed.dart';
part 'applicant_info.g.dart';

/// Postulante visto por el creador de la solicitud (lista de aplicantes).
@freezed
abstract class ApplicantInfo with _$ApplicantInfo {
  const factory ApplicantInfo({
    required String applicationId,
    required String applicantId,
    required String fullName,
    String? avatarUrl,
    @Default(Medal.hierro) Medal medal,
    @Default(0) num avgRating,
    @Default(0) int ratingsCount,
    @Default(0) int totalPoints,
    String? message,
    required ApplicationStatus status,
    String? whatsappNumber,
    required DateTime appliedAt,
  }) = _ApplicantInfo;

  factory ApplicantInfo.fromJson(Map<String, dynamic> json) =>
      _$ApplicantInfoFromJson(json);
}
