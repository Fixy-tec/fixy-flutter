import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/reputation.dart';
import 'tag.dart';

part 'request_summary.freezed.dart';
part 'request_summary.g.dart';

enum RequestType { asesoria, proyecto }

enum RequestStatus { abierta, enRevision, enProceso, completada, cancelada }

/// Datos del creador embebidos en el feed (subset de profiles).
@freezed
abstract class RequestCreator with _$RequestCreator {
  const factory RequestCreator({
    required String id,
    required String fullName,
    String? avatarUrl,
    @Default(Medal.hierro) Medal medal,
    String? whatsappNumber,
  }) = _RequestCreator;

  factory RequestCreator.fromJson(Map<String, dynamic> json) =>
      _$RequestCreatorFromJson(json);
}

/// Vista de una solicitud en el feed: incluye creator + tags + count de postulaciones.
@freezed
abstract class RequestSummary with _$RequestSummary {
  const factory RequestSummary({
    required String id,
    required RequestType type,
    required String title,
    required String description,
    required int difficultyLevel,
    required int basePoints,
    num? economicBenefit,
    @Default(1) int participantsNeeded,
    @Default(RequestStatus.abierta) RequestStatus status,
    DateTime? deadline,
    required DateTime publishedAt,
    required RequestCreator creator,
    @Default(<Tag>[]) List<Tag> tags,
    @Default(0) int applicationsCount,
  }) = _RequestSummary;

  factory RequestSummary.fromJson(Map<String, dynamic> json) =>
      _$RequestSummaryFromJson(json);
}
