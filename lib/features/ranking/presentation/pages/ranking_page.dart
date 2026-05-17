import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/reputation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/ranking_user.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/medal_image.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../providers/ranking_providers.dart';

/// Filtro de medalla aplicado en la vista del Top (cliente-side).
final medalFilterProvider = StateProvider<Medal?>((_) => null);

class RankingPage extends ConsumerWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topAsync = ref.watch(rankingTopProvider);
    final medalFilter = ref.watch(medalFilterProvider);
    final myUid = ref.watch(currentSessionProvider)?.user.id;
    final me = ref.watch(currentUserProvider).value;
    final myRank = ref.watch(myRankProvider).value ?? 0;
    final delta = ref.watch(myWeeklyDeltaProvider).value ?? 0;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ranking')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(rankingTopProvider);
          ref.invalidate(myRankProvider);
          ref.invalidate(myWeeklyDeltaProvider);
          await ref.read(rankingTopProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header gradient
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.secondary, AppColors.primary],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ranking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Tu posicion en el ranking',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card "Tu rango actual"
            if (me != null)
              _MyRankCard(
                medal: me.medal,
                points: me.totalPoints,
                rank: myRank,
                delta: delta,
              ),
            const SizedBox(height: 16),

            // Todas las medallas
            Row(
              children: [
                Icon(
                  Icons.star_outline,
                  color: scheme.onSurfaceVariant,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'TODAS LAS MEDALLAS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _AllMedalsRow(currentMedal: me?.medal),
            const SizedBox(height: 24),

            // Top estudiantes header
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  color: scheme.onSurfaceVariant,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'TOP ESTUDIANTES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _MedalFilterRow(
              selected: medalFilter,
              onSelected: (m) =>
                  ref.read(medalFilterProvider.notifier).state = m,
            ),
            const SizedBox(height: 12),
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
                final filtered = medalFilter == null
                    ? users
                    : users.where((u) => u.medal == medalFilter).toList();
                if (filtered.isEmpty) {
                  return const EmptyState(
                    icon: Icons.leaderboard_outlined,
                    title: 'Sin usuarios para mostrar',
                    subtitle: 'Cambia de filtro o vuelve mas tarde.',
                    inline: true,
                  );
                }
                return Column(
                  children: filtered
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

// ============================================================
// Card "Tu rango actual"
// ============================================================
class _MyRankCard extends StatelessWidget {
  const _MyRankCard({
    required this.medal,
    required this.points,
    required this.rank,
    required this.delta,
  });

  final Medal medal;
  final int points;
  final int rank;
  final int delta;

  String _label(Medal m) => switch (m) {
        Medal.hierro => 'Hierro',
        Medal.bronce => 'Bronce',
        Medal.plata => 'Plata',
        Medal.oro => 'Oro',
        Medal.diamante => 'Diamante',
        Medal.maestro => 'Maestro',
        Medal.challenger => 'Challenger',
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ladderEntry = medalLadder.firstWhere(
      (m) => m.medal == medal,
      orElse: () => medalLadder.first,
    );
    final next = medalLadder
        .where((m) => m.minPoints > ladderEntry.minPoints)
        .toList();
    final hasNext = next.isNotEmpty;
    final nextMedal = hasNext ? next.first : null;
    final progress = hasNext
        ? ((points - ladderEntry.minPoints) /
                (nextMedal!.minPoints - ladderEntry.minPoints))
            .clamp(0.0, 1.0)
        : 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 5,
                        backgroundColor: scheme.surfaceContainerHighest,
                      ),
                    ),
                    MedalImage(medal: medal, size: 60),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TU RANGO ACTUAL',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _label(medal),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _MiniStat(
                            label: 'Tus puntos',
                            value: '$points',
                          ),
                          const SizedBox(width: 8),
                          _MiniStat(
                            label: 'Posicion',
                            value: rank == 0 ? '—' : '#$rank',
                          ),
                          if (delta != 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: (delta > 0
                                        ? AppColors.pointsPositive
                                        : AppColors.pointsNegative)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${delta > 0 ? '+' : ''}$delta',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: delta > 0
                                      ? AppColors.pointsPositive
                                      : AppColors.pointsNegative,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ladderEntry.minPoints} pts',
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (hasNext)
                  Text(
                    '${nextMedal!.minPoints} pts',
                    style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            if (hasNext) ...[
              const SizedBox(height: 4),
              Text(
                '${nextMedal!.minPoints - points} pts para ${_label(nextMedal.medal)}',
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Row con TODAS las medallas (la actual marcada "Tu aqui")
// ============================================================
class _AllMedalsRow extends StatelessWidget {
  const _AllMedalsRow({required this.currentMedal});
  final Medal? currentMedal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: medalLadder.length,
        separatorBuilder: (c, i) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final entry = medalLadder[i];
          final isCurrent = currentMedal == entry.medal;
          final maxLabel = entry.maxPoints == null
              ? '${entry.minPoints}+'
              : '${entry.minPoints}–${entry.maxPoints}';
          return Container(
            width: 90,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isCurrent
                    ? AppColors.primary
                    : Theme.of(context).colorScheme.outlineVariant,
                width: isCurrent ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Tu aqui',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 14),
                const SizedBox(height: 4),
                MedalImage(medal: entry.medal, size: 36),
                const SizedBox(height: 2),
                Text(
                  _label(entry.medal),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
                Text(
                  maxLabel,
                  style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _label(Medal m) => switch (m) {
        Medal.hierro => 'Hierro',
        Medal.bronce => 'Bronce',
        Medal.plata => 'Plata',
        Medal.oro => 'Oro',
        Medal.diamante => 'Diamante',
        Medal.maestro => 'Maestro',
        Medal.challenger => 'Challenger',
      };
}

// ============================================================
// Filtro horizontal por medalla
// ============================================================
class _MedalFilterRow extends StatelessWidget {
  const _MedalFilterRow({required this.selected, required this.onSelected});
  final Medal? selected;
  final ValueChanged<Medal?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('Todos'),
              selected: selected == null,
              showCheckmark: false,
              onSelected: (_) => onSelected(null),
            ),
          ),
          ...Medal.values.reversed.map((m) {
            final isSel = selected == m;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MedalImage(medal: m, size: 16),
                    const SizedBox(width: 4),
                    Text(_label(m)),
                  ],
                ),
                selected: isSel,
                showCheckmark: false,
                onSelected: (_) => onSelected(m),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _label(Medal m) => switch (m) {
        Medal.hierro => 'Hierro',
        Medal.bronce => 'Bronce',
        Medal.plata => 'Plata',
        Medal.oro => 'Oro',
        Medal.diamante => 'Diamante',
        Medal.maestro => 'Maestro',
        Medal.challenger => 'Challenger',
      };
}

// ============================================================
// Tile de un usuario en el ranking
// ============================================================
class _RankingTile extends StatelessWidget {
  const _RankingTile({required this.user, required this.isMe});
  final RankingUser user;
  final bool isMe;

  IconData? _medalIcon(int rank) {
    if (rank == 1) return Icons.workspace_premium;
    if (rank == 2 || rank == 3) return Icons.military_tech;
    return null;
  }

  Color _rankColor(int rank, ColorScheme scheme) => switch (rank) {
        1 => AppColors.medalOro,
        2 => AppColors.medalPlata,
        3 => AppColors.medalBronce,
        _ => scheme.onSurfaceVariant,
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe
            ? scheme.primaryContainer.withValues(alpha: 0.5)
            : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: isMe
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: _medalIcon(user.rank) != null
                ? Icon(
                    _medalIcon(user.rank),
                    color: _rankColor(user.rank, scheme),
                    size: 28,
                  )
                : Text(
                    '#${user.rank}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          UserAvatar(
            fullName: user.fullName,
            // RankingUser hoy no trae avatarSlug; mostramos iniciales.
            radius: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMe ? '${user.fullName} (tu)' : user.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${user.totalPoints} pts',
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          MedalImage(medal: user.medal, size: 32),
        ],
      ),
    );
  }
}
