import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../../../shared/models/rating_received.dart';
import '../../../../shared/models/tag.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/profile_repository.dart';

final profileRepositoryProvider =
    Provider<ProfileRepository>((ref) => ProfileRepository(supabase));

final myRatingsReceivedProvider =
    FutureProvider<List<RatingReceived>>((ref) async {
  final uid = ref.watch(currentSessionProvider)?.user.id;
  if (uid == null) return const [];
  return ref.watch(profileRepositoryProvider).fetchRatingsReceived(uid);
});

final myCompletedCountProvider = FutureProvider<int>((ref) async {
  final uid = ref.watch(currentSessionProvider)?.user.id;
  if (uid == null) return 0;
  return ref.watch(profileRepositoryProvider).fetchCompletedCount(uid);
});

final myRankProvider = FutureProvider<int>((ref) async {
  final uid = ref.watch(currentSessionProvider)?.user.id;
  if (uid == null) return 0;
  return ref.watch(profileRepositoryProvider).fetchUserRank(uid);
});

final myWeeklyDeltaProvider = FutureProvider<int>((ref) async {
  final uid = ref.watch(currentSessionProvider)?.user.id;
  if (uid == null) return 0;
  return ref.watch(profileRepositoryProvider).fetchWeeklyDelta(uid);
});

final myTagsProvider = FutureProvider<List<Tag>>((ref) async {
  final uid = ref.watch(currentSessionProvider)?.user.id;
  if (uid == null) return const [];
  return ref.watch(profileRepositoryProvider).fetchUserTags(uid);
});
