import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/reputation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/rating_received.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/medal_image.dart';
import '../../../../shared/widgets/tag_chip.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../providers/profile_providers.dart';

/// Perfil publico de otro usuario. Read-only.
class PublicProfilePage extends ConsumerWidget {
  const PublicProfilePage({required this.userId, super.key});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(publicProfileProvider(userId));
    final tagsAsync = ref.watch(publicUserTagsProvider(userId));
    final ratingsAsync = ref.watch(publicUserRatingsProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => ErrorRetry(
          error: e,
          onRetry: () => ref.invalidate(publicProfileProvider(userId)),
        ),
        data: (profile) {
          if (profile == null) {
            return const EmptyState(
              icon: Icons.person_off_outlined,
              title: 'Perfil no encontrado',
            );
          }

          final fullName = profile['full_name'] as String;
          final avatarSlug = profile['avatar_slug'] as String?;
          final medal = Medal.values.firstWhere(
            (m) => m.name == (profile['medal'] as String? ?? 'hierro'),
            orElse: () => Medal.hierro,
          );
          final points = profile['total_points'] as int? ?? 0;
          final ratingsCount = profile['ratings_count'] as int? ?? 0;
          final avgRating = (profile['avg_rating'] as num?) ?? 0;
          final career = profile['career'] as String?;
          final cycle = profile['cycle'] as int?;
          final bio = profile['bio'] as String?;
          final portfolio = profile['portfolio_url'] as String?;
          final linkedin = profile['linkedin_url'] as String?;
          final github = profile['github_url'] as String?;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(publicProfileProvider(userId));
              ref.invalidate(publicUserTagsProvider(userId));
              ref.invalidate(publicUserRatingsProvider(userId));
              await ref.read(publicProfileProvider(userId).future);
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: UserAvatar(
                    fullName: fullName,
                    avatarSlug: avatarSlug,
                    radius: 48,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  fullName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${career ?? "—"} · Ciclo ${cycle ?? "—"}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                Center(child: MedalImage(medal: medal, size: 64)),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatBlock(label: 'Puntos', value: '$points'),
                        _StatBlock(
                          label: 'Calificacion',
                          value: ratingsCount == 0
                              ? '—'
                              : avgRating.toStringAsFixed(1),
                        ),
                        _StatBlock(
                          label: 'Ratings',
                          value: '$ratingsCount',
                        ),
                      ],
                    ),
                  ),
                ),
                if (bio != null && bio.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'Sobre mi'),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(bio),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                _SectionHeader(title: 'Especialidades'),
                const SizedBox(height: 8),
                tagsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, st) => Text('Error: $e'),
                  data: (tags) {
                    if (tags.isEmpty) {
                      return const Text('Sin especialidades.');
                    }
                    return Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children:
                          tags.map((t) => TagChip(tag: t, dense: false)).toList(),
                    );
                  },
                ),
                if ((portfolio != null && portfolio.isNotEmpty) ||
                    (linkedin != null && linkedin.isNotEmpty) ||
                    (github != null && github.isNotEmpty)) ...[
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'Enlaces'),
                  const SizedBox(height: 8),
                  if (github != null && github.isNotEmpty)
                    _LinkTile(
                      icon: Icons.code,
                      label: github,
                      url: github,
                    ),
                  if (portfolio != null && portfolio.isNotEmpty)
                    _LinkTile(
                      icon: Icons.public,
                      label: portfolio,
                      url: portfolio,
                    ),
                  if (linkedin != null && linkedin.isNotEmpty)
                    _LinkTile(
                      icon: Icons.work_outline,
                      label: 'LinkedIn',
                      url: linkedin,
                    ),
                ],
                const SizedBox(height: 24),
                _SectionHeader(title: 'Calificaciones recibidas'),
                const SizedBox(height: 8),
                ratingsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, st) => Text('Error: $e'),
                  data: (items) {
                    if (items.isEmpty) {
                      return const Text('Aun no tiene calificaciones.');
                    }
                    return Column(
                      children: items
                          .map((r) => _RatingTile(rating: r))
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
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
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () {
          final uri = Uri.tryParse(url);
          if (uri != null) {
            launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      ),
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
                  if (rating.comment != null &&
                      rating.comment!.isNotEmpty) ...[
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
      ),
    );
  }
}
