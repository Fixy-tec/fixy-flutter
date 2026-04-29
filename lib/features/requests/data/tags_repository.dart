import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/models/tag.dart';

class TagsRepository {
  TagsRepository(this._client);
  final SupabaseClient _client;

  Future<List<Tag>> fetchAll() async {
    final rows = await _client.from('tags').select().order('name');
    return rows.map((r) => Tag.fromJson(r)).toList();
  }
}
