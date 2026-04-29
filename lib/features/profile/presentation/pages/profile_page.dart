import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/reputation.dart';
import '../../../../shared/models/rating_received.dart';
import '../../../../shared/widgets/medal_badge.dart';
import '../../../../shared/widgets/tag_chip.dart';
import '../../../auth/domain/app_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/profile_providers.dart';
import '../widgets/edit_profile_sheet.dart';
import '../widgets/edit_tags_sheet.dart';
import '../widgets/whatsapp_editor_sheet.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            tooltip: 'Editar perfil',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final user = ref.read(currentUserProvider).value;
              if (user != null) {
                await EditProfileSheet.show(context, user);
              }
            },
          ),
          IconButton(
            tooltip: 'Cerrar sesion',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Sin sesion'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(currentUserProvider);
              ref.invalidate(myCompletedCountProvider);
              ref.invalidate(myRankProvider);
              ref.invalidate(myRatingsReceivedProvider);
              ref.invalidate(myTagsProvider);
              await ref.read(currentUserProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _Hero(user: user),
                const SizedBox(height: 16),
                _MedalProgress(user: user),
                const SizedBox(height: 20),
                _StatsRow(),
                const SizedBox(height: 24),
                _SectionHeader(
                  title: 'Especialidades',
                  trailing: TextButton.icon(
                    onPressed: () async {
                      final current = ref.read(myTagsProvider).value ?? [];
                      await EditTagsSheet.show(context, current);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Editar'),
                  ),
                ),
                const SizedBox(height: 8),
                const _MyTagsList(),
                const SizedBox(height: 24),
                _SectionHeader(title: 'WhatsApp'),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(user.whatsappNumber ?? 'No configurado'),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () => WhatsappEditorSheet.show(
                      context,
                      user.whatsappNumber,
                    ),
                  ),
                ),
                if (user.bio != null && user.bio!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'Sobre mi'),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(user.bio!),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                _SectionHeader(title: 'Ultimas calificaciones'),
                const SizedBox(height: 8),
                const _RatingsList(),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
class _Hero extends StatelessWidget {
  const _Hero({required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final initials = user.fullName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
    return Column(
      children: [
        const SizedBox(height: 8),
        CircleAvatar(
          radius: 48,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            initials,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          user.fullName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '${user.career ?? "—"} · Ciclo ${user.cycle ?? "—"}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _MedalProgress extends StatelessWidget {
  const _MedalProgress({required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final ladderEntry = medalLadder.firstWhere(
      (m) => m.medal == user.medal,
      orElse: () => medalLadder.first,
    );
    final next = medalLadder
        .where((m) => m.minPoints > ladderEntry.minPoints)
        .toList();
    final hasNext = next.isNotEmpty;
    final nextMedal = hasNext ? next.first : null;
    final progress = hasNext
        ? ((user.totalPoints - ladderEntry.minPoints) /
                (nextMedal!.minPoints - ladderEntry.minPoints))
            .clamp(0.0, 1.0)
        : 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MedalBadge(medal: user.medal),
                const SizedBox(width: 12),
                Text(
                  '${user.totalPoints} pts',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                if (hasNext)
                  Text(
                    '${nextMedal!.minPoints - user.totalPoints} pts para ${_medalLabel(nextMedal.medal)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  )
                else
                  Text(
                    'Maximo nivel',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _medalLabel(Medal m) => switch (m) {
        Medal.hierro => 'Hierro',
        Medal.bronce => 'Bronce',
        Medal.plata => 'Plata',
        Medal.oro => 'Oro',
        Medal.diamante => 'Diamante',
        Medal.maestro => 'Maestro',
        Medal.challenger => 'Challenger',
      };
}

class _StatsRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final completed = ref.watch(myCompletedCountProvider);
    final rank = ref.watch(myRankProvider);

    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: 'Completadas',
            value: completed.when(
              loading: () => '…',
              error: (e, st) => '—',
              data: (n) => '$n',
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatBox(
            label: 'Rating prom.',
            value: user == null || user.ratingsCount == 0
                ? '—'
                : user.avgRating.toStringAsFixed(1),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatBox(
            label: 'Ranking',
            value: rank.when(
              loading: () => '…',
              error: (e, st) => '—',
              data: (n) => n == 0 ? '—' : '#$n',
            ),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});
  final String title;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
        ),
        const Spacer(),
        ?trailing,
      ],
    );
  }
}

class _MyTagsList extends ConsumerWidget {
  const _MyTagsList();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(myTagsProvider);
    return tagsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(8),
        child: LinearProgressIndicator(),
      ),
      error: (e, _) => Text('Error: $e'),
      data: (tags) {
        if (tags.isEmpty) {
          return const Text('Aun no has agregado especialidades.');
        }
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          children: tags.map((t) => TagChip(tag: t, dense: false)).toList(),
        );
      },
    );
  }
}

class _RatingsList extends ConsumerWidget {
  const _RatingsList();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myRatingsReceivedProvider);
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(8),
        child: LinearProgressIndicator(),
      ),
      error: (e, _) => Text('Error: $e'),
      data: (items) {
        if (items.isEmpty) {
          return const Text('Aun no has recibido calificaciones.');
        }
        return Column(
          children: items.map((r) => _RatingTile(rating: r)).toList(),
        );
      },
    );
  }
}

class _RatingTile extends StatelessWidget {
  const _RatingTile({required this.rating});
  final RatingReceived rating;

  @override
  Widget build(BuildContext context) {
    final initials = rating.raterFullName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rating.raterFullName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (rating.comment != null && rating.comment!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('"${rating.comment!}"'),
                  ],
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                rating.stars,
                (_) => const Icon(
                  Icons.star,
                  size: 16,
                  color: Color(0xFFE6B800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
