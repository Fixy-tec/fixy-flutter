import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/reputation.dart';
import '../../../shared/models/applicant_info.dart';
import '../../../shared/models/application_summary.dart';

class ApplicationsRepository {
  ApplicationsRepository(this._client);
  final SupabaseClient _client;

  /// El usuario se postula a una solicitud.
  Future<void> apply({
    required String requestId,
    required String applicantId,
    String? message,
  }) async {
    await _client.from('applications').insert({
      'request_id': requestId,
      'applicant_id': applicantId,
      'message': message,
    });
  }

  Future<void> approve(String applicationId) async {
    await _client
        .from('applications')
        .update({'status': 'aprobada'}).eq('id', applicationId);
  }

  Future<void> reject(String applicationId) async {
    await _client
        .from('applications')
        .update({'status': 'rechazada'}).eq('id', applicationId);
  }

  /// Retira una postulacion propia (solo si esta pendiente).
  /// RLS exige que sea el postulante (applications_delete_own).
  Future<void> withdraw(String applicationId) async {
    await _client.from('applications').delete().eq('id', applicationId);
  }

  /// Postulantes de un request (visible al creador via RLS).
  Future<List<ApplicantInfo>> listForRequest(String requestId) async {
    final rows = await _client
        .from('applications')
        .select('''
          id, applicant_id, message, status, applied_at,
          applicant:profiles!applications_applicant_id_fkey (
            id, full_name, avatar_url, medal, avg_rating, ratings_count,
            total_points, whatsapp_number
          )
        ''')
        .eq('request_id', requestId)
        .order('applied_at', ascending: false);

    return rows.map((row) {
      final ap = row['applicant'] as Map<String, dynamic>;
      return ApplicantInfo(
        applicationId: row['id'] as String,
        applicantId: ap['id'] as String,
        fullName: ap['full_name'] as String,
        avatarUrl: ap['avatar_url'] as String?,
        medal: Medal.values.firstWhere(
          (m) => m.name == (ap['medal'] as String? ?? 'hierro'),
          orElse: () => Medal.hierro,
        ),
        avgRating: (ap['avg_rating'] as num?) ?? 0,
        ratingsCount: (ap['ratings_count'] as int?) ?? 0,
        totalPoints: (ap['total_points'] as int?) ?? 0,
        message: row['message'] as String?,
        status: switch (row['status'] as String) {
          'aprobada' => ApplicationStatus.aprobada,
          'rechazada' => ApplicationStatus.rechazada,
          _ => ApplicationStatus.pendiente,
        },
        whatsappNumber: ap['whatsapp_number'] as String?,
        appliedAt: DateTime.parse(row['applied_at'] as String),
      );
    }).toList();
  }

  /// Mi postulacion en una solicitud (si existe).
  Future<ApplicantInfo?> findMyApplication({
    required String requestId,
    required String applicantId,
  }) async {
    final row = await _client
        .from('applications')
        .select('''
          id, applicant_id, message, status, applied_at,
          applicant:profiles!applications_applicant_id_fkey (
            id, full_name, avatar_url, medal, avg_rating, ratings_count,
            total_points, whatsapp_number
          )
        ''')
        .eq('request_id', requestId)
        .eq('applicant_id', applicantId)
        .maybeSingle();

    if (row == null) return null;

    final ap = row['applicant'] as Map<String, dynamic>;
    return ApplicantInfo(
      applicationId: row['id'] as String,
      applicantId: ap['id'] as String,
      fullName: ap['full_name'] as String,
      avatarUrl: ap['avatar_url'] as String?,
      medal: Medal.values.firstWhere(
        (m) => m.name == (ap['medal'] as String? ?? 'hierro'),
        orElse: () => Medal.hierro,
      ),
      avgRating: (ap['avg_rating'] as num?) ?? 0,
      ratingsCount: (ap['ratings_count'] as int?) ?? 0,
      totalPoints: (ap['total_points'] as int?) ?? 0,
      message: row['message'] as String?,
      status: switch (row['status'] as String) {
        'aprobada' => ApplicationStatus.aprobada,
        'rechazada' => ApplicationStatus.rechazada,
        _ => ApplicationStatus.pendiente,
      },
      whatsappNumber: ap['whatsapp_number'] as String?,
      appliedAt: DateTime.parse(row['applied_at'] as String),
    );
  }
}
