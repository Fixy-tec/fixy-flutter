import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../../../shared/models/ranking_user.dart';
import '../../data/ranking_repository.dart';

final rankingRepositoryProvider =
    Provider<RankingRepository>((ref) => RankingRepository(supabase));

/// Filtro de area seleccionado en la UI. null = global.
final rankingFilterProvider = StateProvider<String?>((ref) => null);

final rankingTopProvider = FutureProvider<List<RankingUser>>((ref) {
  final tag = ref.watch(rankingFilterProvider);
  return ref.watch(rankingRepositoryProvider).fetchTop(tagSlug: tag);
});
