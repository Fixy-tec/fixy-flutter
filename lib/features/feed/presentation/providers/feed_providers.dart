import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../../../shared/models/request_summary.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/feed_repository.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(supabase);
});

/// Filtro seleccionado en la UI (Todos / Asesorias / Proyectos / Recomendados).
final feedFilterProvider = StateProvider<FeedFilter>((ref) => FeedFilter.todos);

/// Feed de solicitudes segun el filtro actual.
final feedProvider = FutureProvider<List<RequestSummary>>((ref) async {
  final filter = ref.watch(feedFilterProvider);
  final repo = ref.watch(feedRepositoryProvider);
  final session = ref.watch(currentSessionProvider);

  return repo.fetchFeed(
    filter: filter,
    currentUserId: session?.user.id,
  );
});
