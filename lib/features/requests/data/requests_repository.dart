import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/reputation.dart';
import '../../../shared/models/application_summary.dart';
import '../../../shared/models/request_summary.dart';
import '../../../shared/models/tag.dart';

class CreateRequestData {
  const CreateRequestData({
    required this.type,
    required this.title,
    required this.description,
    required this.difficultyLevel,
    required this.tagIds,
    this.economicBenefit,
    this.participantsNeeded = 1,
    this.deadline,
  });

  final RequestType type;
  final String title;
  final String description;
  final int difficultyLevel;
  final List<String> tagIds;
  final num? economicBenefit;
  final int participantsNeeded;
  final DateTime? deadline;
}

class RequestsRepository {
  RequestsRepository(this._client);
  final SupabaseClient _client;

  static const _selectQuery = '''
    id, type, title, description, difficulty_level, base_points,
    economic_benefit, participants_needed, status, deadline, published_at,
    creator:profiles!requests_creator_id_fkey ( id, full_name, avatar_url, medal, whatsapp_number ),
    request_tags ( tag:tags ( id, name, slug, is_custom ) ),
    applications ( count )
  ''';

  /// Crea una solicitud y sus tags asociados. Retorna el id creado.
  Future<String> createRequest(CreateRequestData data, String creatorId) async {
    final inserted = await _client.from('requests').insert({
      'creator_id': creatorId,
      'type': _typeToDb(data.type),
      'title': data.title,
      'description': data.description,
      'difficulty_level': data.difficultyLevel,
      'economic_benefit': data.economicBenefit,
      'participants_needed': data.participantsNeeded,
      'deadline': data.deadline?.toIso8601String().substring(0, 10),
    }).select('id').single();

    final requestId = inserted['id'] as String;

    if (data.tagIds.isNotEmpty) {
      await _client.from('request_tags').insert(
            data.tagIds
                .map((tagId) => {'request_id': requestId, 'tag_id': tagId})
                .toList(),
          );
    }

    return requestId;
  }

  /// Detalle de una solicitud (para la vista de detalle).
  Future<RequestSummary?> fetchById(String id) async {
    final row = await _client
        .from('requests')
        .select(_selectQuery)
        .eq('id', id)
        .maybeSingle();
    if (row == null) return null;
    return _mapRequestRow(row);
  }

  /// Marca la solicitud como completada (solo creador, solo si en proceso).
  Future<void> markCompleted(String requestId) async {
    await _client
        .from('requests')
        .update({'status': 'completada'}).eq('id', requestId);
  }

  /// Cancela la solicitud (solo creador). RLS exige que sea creador.
  /// La app evita cancelar si ya esta en proceso o completada.
  Future<void> cancelRequest(String requestId) async {
    await _client
        .from('requests')
        .update({'status': 'cancelada'}).eq('id', requestId);
  }

  /// Elimina la solicitud por completo (cascade borra applications y tags).
  /// RLS exige que sea creador. La app evita eliminar si ya hay postulantes.
  Future<void> deleteRequest(String requestId) async {
    await _client.from('requests').delete().eq('id', requestId);
  }

  /// Solicitudes creadas por el usuario.
  Future<List<RequestSummary>> fetchMyCreated(String userId) async {
    final rows = await _client
        .from('requests')
        .select(_selectQuery)
        .eq('creator_id', userId)
        .order('published_at', ascending: false);
    return rows.map(_mapRequestRow).toList();
  }

  /// Postulaciones del usuario (con request embebido).
  Future<List<ApplicationSummary>> fetchMyApplications(String userId) async {
    final rows = await _client
        .from('applications')
        .select('''
          id, request_id, applicant_id, message, status, applied_at,
          request:requests!applications_request_id_fkey ( $_selectQuery )
        ''')
        .eq('applicant_id', userId)
        .order('applied_at', ascending: false);

    return rows.map((row) {
      return ApplicationSummary(
        id: row['id'] as String,
        requestId: row['request_id'] as String,
        applicantId: row['applicant_id'] as String,
        message: row['message'] as String?,
        status: _parseAppStatus(row['status'] as String),
        appliedAt: DateTime.parse(row['applied_at'] as String),
        request: _mapRequestRow(row['request'] as Map<String, dynamic>),
      );
    }).toList();
  }

  /// Solicitudes en proceso donde el usuario es creador o postulante aprobado.
  Future<List<RequestSummary>> fetchInProcess(String userId) async {
    final created = await _client
        .from('requests')
        .select(_selectQuery)
        .eq('creator_id', userId)
        .eq('status', 'en_proceso');

    final approved = await _client
        .from('applications')
        .select('request:requests!applications_request_id_fkey ( $_selectQuery )')
        .eq('applicant_id', userId)
        .eq('status', 'aprobada');

    final results = <String, RequestSummary>{};
    for (final r in created) {
      final summary = _mapRequestRow(r);
      results[summary.id] = summary;
    }
    for (final a in approved) {
      final reqJson = a['request'] as Map<String, dynamic>?;
      if (reqJson != null && reqJson['status'] == 'en_proceso') {
        final summary = _mapRequestRow(reqJson);
        results[summary.id] = summary;
      }
    }
    return results.values.toList()
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }

  /// Solicitudes completadas donde el usuario participo.
  Future<List<RequestSummary>> fetchCompleted(String userId) async {
    final created = await _client
        .from('requests')
        .select(_selectQuery)
        .eq('creator_id', userId)
        .eq('status', 'completada');

    final approved = await _client
        .from('applications')
        .select('request:requests!applications_request_id_fkey ( $_selectQuery )')
        .eq('applicant_id', userId)
        .eq('status', 'aprobada');

    final results = <String, RequestSummary>{};
    for (final r in created) {
      final summary = _mapRequestRow(r);
      results[summary.id] = summary;
    }
    for (final a in approved) {
      final reqJson = a['request'] as Map<String, dynamic>?;
      if (reqJson != null && reqJson['status'] == 'completada') {
        final summary = _mapRequestRow(reqJson);
        results[summary.id] = summary;
      }
    }
    return results.values.toList()
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }

  // ---------- mappers ----------

  String _typeToDb(RequestType t) =>
      t == RequestType.proyecto ? 'proyecto' : 'asesoria';

  RequestType _parseType(String s) =>
      s == 'proyecto' ? RequestType.proyecto : RequestType.asesoria;

  RequestStatus _parseStatus(String s) => switch (s) {
        'en_revision' => RequestStatus.enRevision,
        'en_proceso' => RequestStatus.enProceso,
        'completada' => RequestStatus.completada,
        'cancelada' => RequestStatus.cancelada,
        _ => RequestStatus.abierta,
      };

  ApplicationStatus _parseAppStatus(String s) => switch (s) {
        'aprobada' => ApplicationStatus.aprobada,
        'rechazada' => ApplicationStatus.rechazada,
        _ => ApplicationStatus.pendiente,
      };

  Medal _parseMedal(String s) =>
      Medal.values.firstWhere((m) => m.name == s, orElse: () => Medal.hierro);

  RequestSummary _mapRequestRow(Map<String, dynamic> row) {
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
        medal: _parseMedal(creatorJson['medal'] as String? ?? 'hierro'),
        whatsappNumber: creatorJson['whatsapp_number'] as String?,
      ),
      tags: tags,
      applicationsCount: count,
    );
  }
}
