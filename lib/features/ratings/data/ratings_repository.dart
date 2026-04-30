import 'package:supabase_flutter/supabase_flutter.dart';

class RatingsRepository {
  RatingsRepository(this._client);
  final SupabaseClient _client;

  /// Inserta un rating. El trigger SQL calcula y aplica los puntos.
  Future<void> rate({
    required String requestId,
    required String raterId,
    required String ratedId,
    required int stars,
    String? comment,
  }) async {
    await _client.from('ratings').insert({
      'request_id': requestId,
      'rater_id': raterId,
      'rated_id': ratedId,
      'stars': stars,
      'comment': comment,
    });
  }

  /// Devuelve true si ya califique a esa persona en ese request.
  Future<bool> hasRated({
    required String requestId,
    required String raterId,
    required String ratedId,
  }) async {
    final row = await _client
        .from('ratings')
        .select('id')
        .eq('request_id', requestId)
        .eq('rater_id', raterId)
        .eq('rated_id', ratedId)
        .maybeSingle();
    return row != null;
  }

  /// Postulante aprobado de un request (necesario para saber a quien
  /// debe calificar el creador).
  Future<String?> approvedApplicantId(String requestId) async {
    final row = await _client
        .from('applications')
        .select('applicant_id')
        .eq('request_id', requestId)
        .eq('status', 'aprobada')
        .maybeSingle();
    return row?['applicant_id'] as String?;
  }
}
