import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/request_card.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../notifications/presentation/providers/notifications_providers.dart';
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
                  child: ErrorRetry(
                    error: e,
                    inline: true,
                    onRetry: () => ref.invalidate(feedProvider),
                  ),
                ),
                data: (requests) {
                  if (requests.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        icon: Icons.inbox_outlined,
                        title: 'Sin solicitudes',
                        subtitle: filter == FeedFilter.recomendados
                            ? 'Agrega especialidades a tu perfil para recibir recomendaciones.'
                            : 'No hay solicitudes en esta categoria.',
                        inline: true,
                        action: FilledButton.icon(
                          onPressed: () =>
                              context.push('/create-request'),
                          icon: const Icon(Icons.add),
                          label: const Text('Crear solicitud'),
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
                        onTap: () =>
                            context.push('/requests/${requests[i].id}'),
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

class _Header extends ConsumerWidget {
  const _Header({this.greetingName});
  final String? greetingName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final unread = ref.watch(unreadNotificationsCountProvider);

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
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton.filledTonal(
                onPressed: () => context.push('/notifications'),
                icon: const Icon(Icons.notifications_outlined),
              ),
              if (unread > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 18),
                    child: Text(
                      unread > 9 ? '9+' : '$unread',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onError,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
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
