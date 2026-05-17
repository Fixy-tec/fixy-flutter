import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/request_summary.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../feed/data/feed_repository.dart';
import '../../../feed/presentation/providers/feed_providers.dart';

/// Filtros de la pantalla Buscar (mas potentes que el filtro del Inicio).
class SearchFilters {
  const SearchFilters({
    this.type,
    this.payment,
    this.difficulty,
    this.tagSlugs = const <String>{},
    this.query = '',
  });

  /// null = todos
  final RequestType? type;

  /// null = todos, true = con pago, false = voluntario
  final bool? payment;

  /// null = todas, 1-5 nivel
  final int? difficulty;

  /// Tags seleccionados (slugs)
  final Set<String> tagSlugs;

  /// Busqueda libre (titulo, descripcion, tag)
  final String query;

  SearchFilters copyWith({
    Object? type = _sentinel,
    Object? payment = _sentinel,
    Object? difficulty = _sentinel,
    Set<String>? tagSlugs,
    String? query,
  }) {
    return SearchFilters(
      type: identical(type, _sentinel) ? this.type : type as RequestType?,
      payment: identical(payment, _sentinel) ? this.payment : payment as bool?,
      difficulty: identical(difficulty, _sentinel)
          ? this.difficulty
          : difficulty as int?,
      tagSlugs: tagSlugs ?? this.tagSlugs,
      query: query ?? this.query,
    );
  }
}

const _sentinel = Object();

final searchFiltersProvider =
    StateProvider<SearchFilters>((_) => const SearchFilters());

/// Resultado del Buscar: trae todo el feed abierto y filtra en cliente.
/// (Para escalas mayores moveriamos esto a server-side; OK por ahora.)
final searchResultsProvider =
    FutureProvider<List<RequestSummary>>((ref) async {
  final filters = ref.watch(searchFiltersProvider);
  final repo = ref.watch(feedRepositoryProvider);
  final uid = ref.watch(currentSessionProvider)?.user.id;

  final all = await repo.fetchFeed(
    filter: FeedFilter.todos,
    currentUserId: uid,
  );

  Iterable<RequestSummary> result = all;

  if (filters.type != null) {
    result = result.where((r) => r.type == filters.type);
  }
  if (filters.payment != null) {
    result = result.where((r) {
      final hasPayment =
          r.economicBenefit != null && (r.economicBenefit as num) > 0;
      return filters.payment == true ? hasPayment : !hasPayment;
    });
  }
  if (filters.difficulty != null) {
    result = result.where((r) => r.difficultyLevel == filters.difficulty);
  }
  if (filters.tagSlugs.isNotEmpty) {
    result = result.where((r) =>
        r.tags.any((t) => filters.tagSlugs.contains(t.slug)));
  }
  if (filters.query.trim().isNotEmpty) {
    final q = filters.query.trim().toLowerCase();
    result = result.where((r) =>
        r.title.toLowerCase().contains(q) ||
        r.description.toLowerCase().contains(q) ||
        r.tags.any((t) => t.name.toLowerCase().contains(q)));
  }
  return result.toList();
});
