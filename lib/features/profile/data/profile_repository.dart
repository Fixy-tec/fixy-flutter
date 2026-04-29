import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/reputation.dart';
import '../../../shared/models/rating_received.dart';
import '../../../shared/models/tag.dart';

class ProfileUpdateData {
  const ProfileUpdateData({
    this.fullName,
    this.career,
    this.cycle,
    this.bio,
    this.portfolioUrl,
    this.linkedinUrl,
  });

  final String? fullName;
  final String? career;
  final int? cycle;
  final String? bio;
  final String? portfolioUrl;
  final String? linkedinUrl;

  Map<String, dynamic> toJson() => {
        if (fullName != null) 'full_name': fullName,
        if (career != null) 'career': career,
        if (cycle != null) 'cycle': cycle,
        if (bio != null) 'bio': bio,
        if (portfolioUrl != null) 'portfolio_url': portfolioUrl,
        if (linkedinUrl != null) 'linkedin_url': linkedinUrl,
      };
}

class ProfileRepository {
  ProfileRepository(this._client);
  final SupabaseClient _client;

  Future<void> updateProfile(String userId, ProfileUpdateData data) async {
    await _client.from('profiles').update(data.toJson()).eq('id', userId);
  }

  /// Calificaciones recibidas por el usuario, con info del rater.
  Future<List<RatingReceived>> fetchRatingsReceived(String userId,
      {int limit = 5}) async {
    final rows = await _client
        .from('ratings')
        .select('''
          id, stars, comment, created_at,
          rater:profiles!ratings_rater_id_fkey ( id, full_name, medal )
        ''')
        .eq('rated_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return rows.map((row) {
      final r = row['rater'] as Map<String, dynamic>;
      return RatingReceived(
        id: row['id'] as String,
        raterId: r['id'] as String,
        raterFullName: r['full_name'] as String,
        raterMedal: Medal.values.firstWhere(
          (m) => m.name == (r['medal'] as String? ?? 'hierro'),
          orElse: () => Medal.hierro,
        ),
        stars: row['stars'] as int,
        comment: row['comment'] as String?,
        createdAt: DateTime.parse(row['created_at'] as String),
      );
    }).toList();
  }

  /// Cantidad de solicitudes completadas por el usuario (creador o aprobado).
  Future<int> fetchCompletedCount(String userId) async {
    final asCreator = await _client
        .from('requests')
        .select('id')
        .eq('creator_id', userId)
        .eq('status', 'completada');

    final asApplicant = await _client
        .from('applications')
        .select('id, request:requests!applications_request_id_fkey(status)')
        .eq('applicant_id', userId)
        .eq('status', 'aprobada');

    final approvedCompleted = (asApplicant as List)
        .where((row) =>
            (row['request'] as Map<String, dynamic>?)?['status'] ==
            'completada')
        .length;

    return (asCreator as List).length + approvedCompleted;
  }

  /// Tags del usuario.
  Future<List<Tag>> fetchUserTags(String userId) async {
    final rows = await _client
        .from('user_tags')
        .select('tag:tags(*)')
        .eq('user_id', userId);
    return rows
        .map((r) => Tag.fromJson(r['tag'] as Map<String, dynamic>))
        .toList();
  }

  Future<void> addTag(String userId, String tagId) async {
    await _client.from('user_tags').insert({
      'user_id': userId,
      'tag_id': tagId,
    });
  }

  Future<void> removeTag(String userId, String tagId) async {
    await _client
        .from('user_tags')
        .delete()
        .eq('user_id', userId)
        .eq('tag_id', tagId);
  }

  /// Calcula la posicion del usuario en el ranking global.
  /// Devuelve 1 para el primero, etc.
  Future<int> fetchUserRank(String userId, {String? tagSlug}) async {
    if (tagSlug == null) {
      // Global
      final mePts = await _client
          .from('profiles')
          .select('total_points')
          .eq('id', userId)
          .maybeSingle();
      if (mePts == null) return 0;
      final myPoints = mePts['total_points'] as int;
      final ahead = await _client
          .from('profiles')
          .select('id')
          .gt('total_points', myPoints)
          .count(CountOption.exact);
      return ahead.count + 1;
    }

    // Por area: rank entre usuarios que comparten un tag
    final users = await _topUsersForTag(tagSlug);
    final idx = users.indexWhere((u) => u['id'] == userId);
    return idx == -1 ? 0 : idx + 1;
  }

  Future<List<Map<String, dynamic>>> _topUsersForTag(String tagSlug) async {
    final tag = await _client
        .from('tags')
        .select('id')
        .eq('slug', tagSlug)
        .maybeSingle();
    if (tag == null) return [];
    final tagId = tag['id'] as String;

    final rows = await _client
        .from('user_tags')
        .select('user:profiles!user_tags_user_id_fkey(id, total_points)')
        .eq('tag_id', tagId);

    final users = (rows as List)
        .map((r) => r['user'] as Map<String, dynamic>)
        .toList()
      ..sort((a, b) => (b['total_points'] as int).compareTo(a['total_points'] as int));
    return users;
  }

  /// Suma de deltas en point_log de los ultimos 7 dias.
  Future<int> fetchWeeklyDelta(String userId) async {
    final since = DateTime.now().subtract(const Duration(days: 7));
    final rows = await _client
        .from('point_log')
        .select('delta')
        .eq('user_id', userId)
        .gte('created_at', since.toIso8601String());
    return (rows as List).fold<int>(
      0,
      (acc, r) => acc + (r['delta'] as int),
    );
  }
}
