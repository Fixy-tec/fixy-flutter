import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/reputation.dart';
import '../../../shared/models/request_summary.dart';
import '../../../shared/models/tag.dart';

enum FeedFilter { todos, asesorias, proyectos, recomendados }

class FeedRepository {
  FeedRepository(this._client);
  final SupabaseClient _client;

  static const _selectQuery = '''
    id, type, title, description, difficulty_level, base_points,
    economic_benefit, participants_needed, status, deadline, published_at,
    creator:profiles!requests_creator_id_fkey ( id, full_name, avatar_url, avatar_slug, medal, whatsapp_number ),
    request_tags ( tag:tags ( id, name, slug, is_custom ) ),
    applications ( count )
  ''';

  /// Lee el feed de solicitudes abiertas. Si filter == recomendados,
  /// solo trae las que coinciden con los tags del usuario.
  Future<List<RequestSummary>> fetchFeed({
    FeedFilter filter = FeedFilter.todos,
    String? currentUserId,
  }) async {
    final query = _client
        .from('requests')
        .select(_selectQuery)
        .eq('status', 'abierta');

    final filtered = switch (filter) {
      FeedFilter.asesorias => query.eq('type', 'asesoria'),
      FeedFilter.proyectos => query.eq('type', 'proyecto'),
      _ => query,
    };

    final rows = await filtered.order('published_at', ascending: false);
    var summaries = rows.map(_mapRow).toList();

    if (filter == FeedFilter.recomendados && currentUserId != null) {
      final myTagIds = await _fetchUserTagIds(currentUserId);
      summaries = summaries
          .where((r) => r.tags.any((t) => myTagIds.contains(t.id)))
          .toList();
    }

    return summaries;
  }

  Future<Set<String>> _fetchUserTagIds(String userId) async {
    final rows = await _client
        .from('user_tags')
        .select('tag_id')
        .eq('user_id', userId);
    return rows.map((r) => r['tag_id'] as String).toSet();
  }

  RequestSummary _mapRow(Map<String, dynamic> row) {
    final creatorJson = row['creator'] as Map<String, dynamic>;
    final tagsRaw = row['request_tags'] as List<dynamic>? ?? const [];
    final tags = tagsRaw
        .map((e) => Tag.fromJson((e as Map<String, dynamic>)['tag']))
        .toList();
    final apps = row['applications'] as List<dynamic>? ?? const [];
    final count = apps.isNotEmpty ? (apps.first['count'] as int? ?? 0) : 0;

    return RequestSummary(
      id: row['id'] as String,
      type: _parseType(row['type'] as String),
      title: row['title'] as String,
      description: row['description'] as String,
      difficultyLevel: row['difficulty_level'] as int,
      basePoints: row['base_points'] as int,
      economicBenefit: row['economic_benefit'] as num?,
      participantsNeeded: row['participants_needed'] as int? ?? 1,
      status: _parseStatus(row['status'] as String),
      deadline: row['deadline'] != null
          ? DateTime.parse(row['deadline'] as String)
          : null,
      publishedAt: DateTime.parse(row['published_at'] as String),
      creator: RequestCreator(
        id: creatorJson['id'] as String,
        fullName: creatorJson['full_name'] as String,
        avatarUrl: creatorJson['avatar_url'] as String?,
        avatarSlug: creatorJson['avatar_slug'] as String?,
        medal: _parseMedal(creatorJson['medal'] as String? ?? 'hierro'),
        whatsappNumber: creatorJson['whatsapp_number'] as String?,
      ),
      tags: tags,
      applicationsCount: count,
    );
  }

  RequestType _parseType(String s) =>
      s == 'proyecto' ? RequestType.proyecto : RequestType.asesoria;

  RequestStatus _parseStatus(String s) => switch (s) {
        'en_revision' => RequestStatus.enRevision,
        'en_proceso' => RequestStatus.enProceso,
        'completada' => RequestStatus.completada,
        'cancelada' => RequestStatus.cancelada,
        _ => RequestStatus.abierta,
      };

  Medal _parseMedal(String s) => Medal.values.firstWhere(
        (m) => m.name == s,
        orElse: () => Medal.hierro,
      );
}
