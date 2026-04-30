import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/ratings_repository.dart';

final ratingsRepositoryProvider =
    Provider<RatingsRepository>((ref) => RatingsRepository(supabase));

/// id del usuario al que tengo que calificar en este request, o null si no aplica.
class CounterpartLookup {
  const CounterpartLookup({required this.requestId, required this.creatorId});
  final String requestId;
  final String creatorId;

  @override
  bool operator ==(Object other) =>
      other is CounterpartLookup &&
      other.requestId == requestId &&
      other.creatorId == creatorId;

  @override
  int get hashCode => Object.hash(requestId, creatorId);
}

final counterpartIdProvider =
    FutureProvider.family<String?, CounterpartLookup>((ref, lookup) async {
  final myId = ref.watch(currentSessionProvider)?.user.id;
  if (myId == null) return null;
  // Si soy el creador -> mi contraparte es el postulante aprobado.
  // Si soy el postulante aprobado -> mi contraparte es el creador.
  if (myId == lookup.creatorId) {
    return ref.watch(ratingsRepositoryProvider).approvedApplicantId(lookup.requestId);
  }
  return lookup.creatorId;
});

class RatingExistsLookup {
  const RatingExistsLookup({
    required this.requestId,
    required this.ratedId,
  });
  final String requestId;
  final String ratedId;

  @override
  bool operator ==(Object other) =>
      other is RatingExistsLookup &&
      other.requestId == requestId &&
      other.ratedId == ratedId;

  @override
  int get hashCode => Object.hash(requestId, ratedId);
}

final hasRatedProvider =
    FutureProvider.family<bool, RatingExistsLookup>((ref, lookup) async {
  final myId = ref.watch(currentSessionProvider)?.user.id;
  if (myId == null) return false;
  return ref.watch(ratingsRepositoryProvider).hasRated(
        requestId: lookup.requestId,
        raterId: myId,
        ratedId: lookup.ratedId,
      );
});
