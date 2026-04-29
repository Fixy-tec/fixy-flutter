import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../../../shared/models/application_summary.dart';
import '../../../../shared/models/request_summary.dart';
import '../../../../shared/models/tag.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/requests_repository.dart';
import '../../data/tags_repository.dart';

final tagsRepositoryProvider = Provider<TagsRepository>((ref) {
  return TagsRepository(supabase);
});

final tagCatalogProvider = FutureProvider<List<Tag>>((ref) {
  return ref.watch(tagsRepositoryProvider).fetchAll();
});

final requestsRepositoryProvider = Provider<RequestsRepository>((ref) {
  return RequestsRepository(supabase);
});

// ---------- Mis solicitudes ----------

final myCreatedRequestsProvider =
    FutureProvider<List<RequestSummary>>((ref) async {
  final uid = ref.watch(currentSessionProvider)?.user.id;
  if (uid == null) return const [];
  return ref.watch(requestsRepositoryProvider).fetchMyCreated(uid);
});

final myApplicationsProvider =
    FutureProvider<List<ApplicationSummary>>((ref) async {
  final uid = ref.watch(currentSessionProvider)?.user.id;
  if (uid == null) return const [];
  return ref.watch(requestsRepositoryProvider).fetchMyApplications(uid);
});

final myInProcessProvider =
    FutureProvider<List<RequestSummary>>((ref) async {
  final uid = ref.watch(currentSessionProvider)?.user.id;
  if (uid == null) return const [];
  return ref.watch(requestsRepositoryProvider).fetchInProcess(uid);
});

final myCompletedProvider =
    FutureProvider<List<RequestSummary>>((ref) async {
  final uid = ref.watch(currentSessionProvider)?.user.id;
  if (uid == null) return const [];
  return ref.watch(requestsRepositoryProvider).fetchCompleted(uid);
});
