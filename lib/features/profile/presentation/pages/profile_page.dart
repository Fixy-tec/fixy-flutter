import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/reputation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/rating_received.dart';
import '../../../../shared/widgets/medal_image.dart';
import '../../../../shared/widgets/tag_chip.dart';
import '../../../../shared/widgets/user_avatar.dart';
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
              padding: const EdgeInsets.all(16),
              children: [
                _HeroCard(user: user),
                const SizedBox(height: 16),
                if (user.bio != null && user.bio!.isNotEmpty) ...[
                  _SectionCard(
                    title: 'SOBRE MI',
                    child: Text(user.bio!),
                  ),
                  const SizedBox(height: 12),
                ],
                _SectionCard(
                  title: 'TECNOLOGIAS',
                  trailing: TextButton.icon(
                    onPressed: () async {
                      final current = ref.read(myTagsProvider).value ?? [];
                      await EditTagsSheet.show(context, current);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Editar'),
                  ),
                  child: const _MyTagsList(),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'CONTACTO',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.phone),
                    title: Text(
                      user.whatsappNumber ?? 'No configurado',
                    ),
                    subtitle: const Text(
                      'Solo visible cuando aprueben tu postulacion',
                      style: TextStyle(fontSize: 11),
                    ),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () => WhatsappEditorSheet.show(
                      context,
                      user.whatsappNumber,
                    ),
                  ),
                ),
                if (_hasAnyLink(user)) ...[
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'LINKS',
                    child: Column(
                      children: [
                        if (user.githubUrl != null && user.githubUrl!.isNotEmpty)
                          _LinkTile(
                            icon: Icons.code,
                            label: user.githubUrl!,
                            url: user.githubUrl!,
                          ),
                        if (user.linkedinUrl != null &&
                            user.linkedinUrl!.isNotEmpty)
                          _LinkTile(
                            icon: Icons.business_center_outlined,
                            label: user.linkedinUrl!,
                            url: user.linkedinUrl!,
                          ),
                        if (user.portfolioUrl != null &&
                            user.portfolioUrl!.isNotEmpty)
                          _LinkTile(
                            icon: Icons.public,
                            label: user.portfolioUrl!,
                            url: user.portfolioUrl!,
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'ULTIMAS CALIFICACIONES',
                  child: const _RatingsList(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _hasAnyLink(AppUser user) {
    return (user.githubUrl?.isNotEmpty ?? false) ||
        (user.linkedinUrl?.isNotEmpty ?? false) ||
        (user.portfolioUrl?.isNotEmpty ?? false);
  }
}

// ============================================================
// Hero: avatar + nombre + carrera + 4 stats + progress
// ============================================================
class _HeroCard extends ConsumerWidget {
  const _HeroCard({required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = ref.watch(myCompletedCountProvider);
    final rank = ref.watch(myRankProvider);
    final scheme = Theme.of(context).colorScheme;

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
          children: [
            Row(
              children: [
                UserAvatar(
                  fullName: user.fullName,
                  avatarSlug: user.avatarSlug,
                  radius: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.career ?? 'Sin carrera',
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      if (user.cycle != null)
                        Text(
                          'Ciclo ${user.cycle}',
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                MedalImage(medal: user.medal, size: 56),
              ],
            ),
            const SizedBox(height: 16),
            // 4 stats grid
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    label: 'Puntos',
                    value: '${user.totalPoints}',
                    color: AppColors.primary,
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
                const SizedBox(width: 8),
                Expanded(
                  child: _StatBox(
                    label: 'Rating',
                    value: user.ratingsCount == 0
                        ? '—'
                        : '★ ${user.avgRating.toStringAsFixed(1)}',
                    color: AppColors.medalOro,
                  ),
                ),
                const SizedBox(width: 8),
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
              ],
            ),
            const SizedBox(height: 16),
            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_medalLabel(user.medal)} · ${ladderEntry.minPoints} pts',
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    if (hasNext)
                      Text(
                        '${_medalLabel(nextMedal!.medal)} · ${nextMedal.minPoints} pts',
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 6),
                if (hasNext)
                  Text(
                    '${nextMedal!.minPoints - user.totalPoints} pts para ${_medalLabel(nextMedal.medal)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  )
                else
                  const Text(
                    'Maximo nivel alcanzado',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.medalChallenger,
                    ),
                  ),
              ],
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

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Section card wrapper
// ============================================================
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

// ============================================================
class _MyTagsList extends ConsumerWidget {
  const _MyTagsList();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(myTagsProvider);
    return tagsAsync.when(
      loading: () => const LinearProgressIndicator(),
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

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.icon, required this.label, required this.url});
  final IconData icon;
  final String label;
  final String url;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () {
        final uri = Uri.tryParse(url);
        if (uri != null) {
          launchUrl(uri, mode: LaunchMode.externalApplication);
        }
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
      loading: () => const LinearProgressIndicator(),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(fullName: rating.raterFullName, radius: 16),
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
                color: AppColors.medalOro,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
