import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/request_card.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/feed_repository.dart';
import '../providers/feed_providers.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(feedFilterProvider);
    final feedAsync = ref.watch(feedProvider);
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(feedProvider.future),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _Header(greetingName: userAsync.value?.fullName),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterBarDelegate(
                  filter: filter,
                  onChanged: (f) =>
                      ref.read(feedFilterProvider.notifier).state = f,
                ),
              ),
              feedAsync.when(
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Error: $e')),
                ),
                data: (requests) {
                  if (requests.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'No hay solicitudes en esta categoria.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    sliver: SliverList.separated(
                      itemCount: requests.length,
                      separatorBuilder: (context, i) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, i) => RequestCard(
                        request: requests[i],
                        onTap: () {
                          // Detalle de solicitud - Sprint 5
                        },
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
        onPressed: () {
          // Crear solicitud - Sprint 4
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Crear solicitud - Sprint 4')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.greetingName});
  final String? greetingName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fixy',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (greetingName != null)
                  Text(
                    'Hola, ${greetingName!.split(' ').first}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () {
              // Notificaciones - Sprint 8
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
    );
  }
}

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  _FilterBarDelegate({required this.filter, required this.onChanged});

  final FeedFilter filter;
  final ValueChanged<FeedFilter> onChanged;

  static const _options = [
    (FeedFilter.todos, 'Todo'),
    (FeedFilter.asesorias, 'Asesorias'),
    (FeedFilter.proyectos, 'Proyectos'),
    (FeedFilter.recomendados, 'Recomendados'),
  ];

  @override
  double get minExtent => 56;
  @override
  double get maxExtent => 56;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _options.length,
        separatorBuilder: (context, i) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (value, label) = _options[i];
          final selected = filter == value;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => onChanged(value),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FilterBarDelegate old) =>
      old.filter != filter;
}
