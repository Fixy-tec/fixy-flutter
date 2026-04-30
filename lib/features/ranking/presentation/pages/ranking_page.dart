import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/ranking_user.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/medal_badge.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../providers/ranking_providers.dart';

class RankingPage extends ConsumerWidget {
  const RankingPage({super.key});

  static const _tabs = <(String?, String)>[
    (null, 'Global'),
    ('flutter', 'Flutter'),
    ('redes', 'Redes'),
    ('matematicas', 'Matematicas'),
    ('algoritmos', 'Algoritmos'),
    ('diseno-ux', 'Diseno UX'),
    ('linux', 'Linux'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(rankingFilterProvider);
    final topAsync = ref.watch(rankingTopProvider);
    final myUid = ref.watch(currentSessionProvider)?.user.id;
    final me = ref.watch(currentUserProvider).value;
    final myRank = ref.watch(myRankProvider).value ?? 0;
    final delta = ref.watch(myWeeklyDeltaProvider).value ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(child: Text('TECSUP')),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(rankingTopProvider);
          ref.invalidate(myRankProvider);
          ref.invalidate(myWeeklyDeltaProvider);
          await ref.read(rankingTopProvider.future);
        },
        child: ListView(
          children: [
            _FilterBar(
              tabs: _tabs,
              selected: filter,
              onSelected: (slug) =>
                  ref.read(rankingFilterProvider.notifier).state = slug,
            ),
            if (me != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: _MyPositionCard(
                  rank: myRank,
                  points: me.totalPoints,
                  medalLabel: me.medal.name,
                  weeklyDelta: delta,
                ),
              ),
            const SizedBox(height: 8),
            topAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => ErrorRetry(
                error: e,
                inline: true,
                onRetry: () => ref.invalidate(rankingTopProvider),
              ),
              data: (users) {
                if (users.isEmpty) {
                  return const EmptyState(
                    icon: Icons.leaderboard_outlined,
                    title: 'Sin usuarios para mostrar',
                    subtitle: 'Cambia de filtro o vuelve mas tarde.',
                    inline: true,
                  );
                }
                return Column(
                  children: users
                      .map((u) => _RankingTile(
                            user: u,
                            isMe: u.id == myUid,
                          ))
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.tabs,
    required this.selected,
    required this.onSelected,
  });

  final List<(String?, String)> tabs;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: tabs.length,
        separatorBuilder: (context, i) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (slug, label) = tabs[i];
          final isSelected = slug == selected;
          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => onSelected(slug),
          );
        },
      ),
    );
  }
}

class _MyPositionCard extends StatelessWidget {
  const _MyPositionCard({
    required this.rank,
    required this.points,
    required this.medalLabel,
    required this.weeklyDelta,
  });

  final int rank;
  final int points;
  final String medalLabel;
  final int weeklyDelta;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              rank == 0 ? '#—' : '#$rank',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tu posicion',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$points pts · $medalLabel',
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (weeklyDelta != 0)
              Text(
                '${weeklyDelta > 0 ? '+' : ''}$weeklyDelta esta semana',
                style: TextStyle(
                  color: weeklyDelta > 0
                      ? AppColors.pointsPositive
                      : AppColors.pointsNegative,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RankingTile extends StatelessWidget {
  const _RankingTile({required this.user, required this.isMe});
  final RankingUser user;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initials = user.fullName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
    final rankColor = switch (user.rank) {
      1 => AppColors.medalOro,
      2 => AppColors.medalPlata,
      3 => AppColors.medalBronce,
      _ => scheme.onSurfaceVariant,
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isMe ? scheme.primaryContainer : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: SizedBox(
          width: 28,
          child: Text(
            '${user.rank}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: rankColor,
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMe ? '${user.fullName} (tu)' : user.fullName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${user.totalPoints} pts',
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: MedalBadge(medal: user.medal, compact: true),
      ),
    );
  }
}
