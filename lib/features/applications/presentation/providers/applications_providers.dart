import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../../../shared/models/applicant_info.dart';
import '../../../../shared/models/request_summary.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../requests/presentation/providers/requests_providers.dart';
import '../../data/applications_repository.dart';

final applicationsRepositoryProvider =
    Provider<ApplicationsRepository>((ref) => ApplicationsRepository(supabase));

/// Detalle de una solicitud por id.
final requestDetailProvider =
    FutureProvider.family<RequestSummary?, String>((ref, id) async {
  final repo = ref.watch(requestsRepositoryProvider);
  return repo.fetchById(id);
});

/// Postulantes de una solicitud (solo visible para el creador via RLS).
final applicantsForRequestProvider =
    FutureProvider.family<List<ApplicantInfo>, String>((ref, requestId) {
  return ref.watch(applicationsRepositoryProvider).listForRequest(requestId);
});

/// Mi postulacion en una solicitud (null si no he postulado).
final myApplicationOnRequestProvider =
    FutureProvider.family<ApplicantInfo?, String>((ref, requestId) async {
  final uid = ref.watch(currentSessionProvider)?.user.id;
  if (uid == null) return null;
  return ref.watch(applicationsRepositoryProvider).findMyApplication(
        requestId: requestId,
        applicantId: uid,
      );
});
