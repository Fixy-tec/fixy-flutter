import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/reputation.dart';
import '../../../shared/models/ranking_user.dart';

class RankingRepository {
  RankingRepository(this._client);
  final SupabaseClient _client;

  /// Top N usuarios. Si tagSlug != null filtra por usuarios con ese tag.
  Future<List<RankingUser>> fetchTop({
    String? tagSlug,
    int limit = 50,
  }) async {
    if (tagSlug == null) {
      final rows = await _client
          .from('profiles')
          .select('id, full_name, avatar_url, total_points, medal')
          .order('total_points', ascending: false)
          .limit(limit);
      return _withRank(rows);
    }

    final tag = await _client
        .from('tags')
        .select('id')
        .eq('slug', tagSlug)
        .maybeSingle();
    if (tag == null) return const [];

    final rows = await _client
        .from('user_tags')
        .select('''
          user:profiles!user_tags_user_id_fkey
            (id, full_name, avatar_url, total_points, medal)
        ''')
        .eq('tag_id', tag['id'] as String);

    final flat = (rows as List)
        .map((r) => r['user'] as Map<String, dynamic>)
        .toList()
      ..sort((a, b) =>
          (b['total_points'] as int).compareTo(a['total_points'] as int));

    return _withRank(flat.take(limit).toList());
  }

  List<RankingUser> _withRank(List<dynamic> rows) {
    return List<RankingUser>.generate(rows.length, (i) {
      final r = rows[i] as Map<String, dynamic>;
      return RankingUser(
        rank: i + 1,
        id: r['id'] as String,
        fullName: r['full_name'] as String,
        avatarUrl: r['avatar_url'] as String?,
        totalPoints: r['total_points'] as int,
        medal: Medal.values.firstWhere(
          (m) => m.name == (r['medal'] as String? ?? 'hierro'),
          orElse: () => Medal.hierro,
        ),
      );
    });
  }
}
