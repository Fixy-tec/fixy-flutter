import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/request_card.dart';
import '../../../requests/presentation/providers/requests_providers.dart';
import '../providers/search_providers.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  bool _showFilters = false;
  final _queryCtrl = TextEditingController();

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(searchFiltersProvider);
    final resultsAsync = ref.watch(searchResultsProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar')),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(searchResultsProvider.future),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Search bar + filtros button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _queryCtrl,
                          onChanged: (q) {
                            ref.read(searchFiltersProvider.notifier).state =
                                filters.copyWith(query: q);
                          },
                          decoration: InputDecoration(
                            hintText: 'Buscar por titulo, descripcion o tag...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _queryCtrl.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () {
                                      _queryCtrl.clear();
                                      ref
                                          .read(searchFiltersProvider.notifier)
                                          .state = filters.copyWith(query: '');
                                      setState(() {});
                                    },
                                  )
                                : null,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: 'Filtros',
                        onPressed: () =>
                            setState(() => _showFilters = !_showFilters),
                        icon: Icon(
                          _showFilters ? Icons.tune : Icons.tune,
                          color: _showFilters ? scheme.primary : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Chips horizontales scope
              SliverToBoxAdapter(
                child: _ScopeChips(
                  scope: filters.scope,
                  onChanged: (s) {
                    ref.read(searchFiltersProvider.notifier).state =
                        filters.copyWith(scope: s);
                  },
                ),
              ),
              // Panel de filtros avanzados (colapsable)
              if (_showFilters)
                SliverToBoxAdapter(
                  child: _FiltersPanel(filters: filters),
                ),
              // Contador
              SliverToBoxAdapter(
                child: resultsAsync.maybeWhen(
                  data: (items) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Text(
                      '${items.length} solicitudes encontradas',
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
              // Resultados
              resultsAsync.when(
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorRetry(
                    error: e,
                    inline: true,
                    onRetry: () => ref.invalidate(searchResultsProvider),
                  ),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        icon: Icons.search_off,
                        title: 'Sin resultados',
                        subtitle: 'Prueba con otros filtros o palabras.',
                        inline: true,
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    sliver: SliverList.separated(
                      itemCount: items.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => RequestCard(
                        request: items[i],
                        onTap: () =>
                            context.push('/requests/${items[i].id}'),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-request'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ============================================================
// Chips horizontales: Todo / Asesorias / Proyectos / Recomendados
// ============================================================
class _ScopeChips extends StatelessWidget {
  const _ScopeChips({required this.scope, required this.onChanged});
  final SearchScope scope;
  final ValueChanged<SearchScope> onChanged;

  static const _items = <(SearchScope, String, IconData)>[
    (SearchScope.todo, 'Todo', Icons.apps),
    (SearchScope.asesorias, 'Asesorias', Icons.menu_book_outlined),
    (SearchScope.proyectos, 'Proyectos', Icons.rocket_launch_outlined),
    (SearchScope.recomendados, 'Recomendados', Icons.auto_awesome),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: _items.length,
        separatorBuilder: (c, i) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (value, label, icon) = _items[i];
          final isSel = scope == value;
          return ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14),
                const SizedBox(width: 4),
                Text(label),
              ],
            ),
            selected: isSel,
            showCheckmark: false,
            onSelected: (_) => onChanged(value),
          );
        },
      ),
    );
  }
}

// ============================================================
// Panel de filtros avanzados (colapsable)
// ============================================================
class _FiltersPanel extends ConsumerWidget {
  const _FiltersPanel({required this.filters});
  final SearchFilters filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagCatalogProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _FilterColumn(
                      title: 'COMPENSACION',
                      options: const [
                        (null, 'Todos'),
                        (true, 'Con pago'),
                        (false, 'Voluntario'),
                      ],
                      selected: filters.payment,
                      onSelected: (v) {
                        ref.read(searchFiltersProvider.notifier).state =
                            filters.copyWith(payment: v as bool?);
                      },
                    ),
                  ),
                  Expanded(
                    child: _FilterColumn(
                      title: 'DIFICULTAD',
                      options: const [
                        (null, 'Todas'),
                        (1, 'Nivel 1'),
                        (2, 'Nivel 2'),
                        (3, 'Nivel 3'),
                        (4, 'Nivel 4'),
                        (5, 'Nivel 5'),
                      ],
                      selected: filters.difficulty,
                      onSelected: (v) {
                        ref.read(searchFiltersProvider.notifier).state =
                            filters.copyWith(difficulty: v as int?);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'TAGS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              tagsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
                data: (tags) {
                  return Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: tags.map((t) {
                      final isSel = filters.tagSlugs.contains(t.slug);
                      return FilterChip(
                        label: Text(t.name),
                        selected: isSel,
                        onSelected: (v) {
                          final next = {...filters.tagSlugs};
                          if (v) {
                            next.add(t.slug);
                          } else {
                            next.remove(t.slug);
                          }
                          ref.read(searchFiltersProvider.notifier).state =
                              filters.copyWith(tagSlugs: next);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterColumn extends StatelessWidget {
  const _FilterColumn({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<(Object?, String)> options;
  final Object? selected;
  final ValueChanged<Object?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        ...options.map((o) {
          final (value, label) = o;
          final isSel = selected == value;
          return InkWell(
            onTap: () => onSelected(value),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    isSel
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 14,
                    color: isSel
                        ? AppColors.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
