import 'package:freezed_annotation/freezed_annotation.dart';

import 'request_summary.dart';

part 'application_summary.freezed.dart';
part 'application_summary.g.dart';

enum ApplicationStatus { pendiente, aprobada, rechazada }

/// Postulacion del usuario actual con la solicitud asociada embebida.
@freezed
abstract class ApplicationSummary with _$ApplicationSummary {
  const factory ApplicationSummary({
    required String id,
    required String requestId,
    required String applicantId,
    String? message,
    required ApplicationStatus status,
    required DateTime appliedAt,
    required RequestSummary request,
  }) = _ApplicationSummary;

  factory ApplicationSummary.fromJson(Map<String, dynamic> json) =>
      _$ApplicationSummaryFromJson(json);
}
