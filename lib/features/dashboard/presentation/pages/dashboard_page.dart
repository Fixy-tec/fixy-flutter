import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/update/update_banner.dart';
import '../../../../core/utils/time_ago.dart';
import '../../../../shared/models/app_notification.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../notifications/presentation/providers/notifications_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

/// Dashboard de Inicio: welcome card, actividad reciente, comunidad.
/// El feed con filtros vive ahora en la tab "Buscar".
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final tagsAsync = ref.watch(myTagsProvider);
    final notifications = ref.watch(notificationsStreamProvider).value ?? [];

    final firstName = (user?.fullName ?? '').split(' ').first;
    final myTagNames = (tagsAsync.value ?? const [])
        .take(4)
        .map((t) => t.name)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentUserProvider);
            ref.invalidate(myTagsProvider);
            await ref.read(currentUserProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header con campana
              _DashboardHeader(),
              const UpdateBanner(),
              const SizedBox(height: 12),
              _WelcomeCard(
                firstName: firstName,
                myTagNames: myTagNames,
              ),
              const SizedBox(height: 16),
              _NewsCard(),
              const SizedBox(height: 24),
              _SectionHeader(
                icon: Icons.notifications_active_outlined,
                title: 'ACTIVIDAD RECIENTE',
              ),
              const SizedBox(height: 8),
              _ActivityList(notifications: notifications.take(4).toList()),
              const SizedBox(height: 24),
              _SectionHeader(
                icon: Icons.people_outline,
                title: 'COMUNIDAD',
              ),
              const SizedBox(height: 8),
              _CommunityCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
class _DashboardHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationsCountProvider);
    return Row(
      children: [
        Image.asset(
          'assets/logo.png',
          height: 36,
          fit: BoxFit.contain,
        ),
        const Spacer(),
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
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(minWidth: 18),
                  child: Text(
                    unread > 9 ? '9+' : '$unread',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.firstName, required this.myTagNames});
  final String firstName;
  final List<String> myTagNames;

  @override
  Widget build(BuildContext context) {
    final tagText = myTagNames.isEmpty
        ? 'Completa tus tecnologias en tu perfil para recibir recomendaciones.'
        : 'Encontramos nuevas solicitudes compatibles con tus habilidades en '
            '${myTagNames.join(', ')}.';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome,
                  color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                firstName.isEmpty ? 'Bienvenido' : 'Bienvenido, $firstName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            tagText,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          if (myTagNames.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: myTagNames
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          t,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.push('/search'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('Explorar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.push('/create-request'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Crear'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
class _NewsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'NOVEDADES',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: AppColors.warning,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto-actualizaciones',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Cada nueva version de Fixy llega como banner al abrir la app.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.system_update, size: 28),
          ],
        ),
      ),
    );
  }
}

// ============================================================
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      children: [
        Icon(icon, size: 16, color: c),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: c,
          ),
        ),
      ],
    );
  }
}

// ============================================================
class _ActivityList extends StatelessWidget {
  const _ActivityList({required this.notifications});
  final List<AppNotification> notifications;

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.inbox_outlined),
          title: const Text('Sin actividad reciente'),
          subtitle: Text(
            'Cuando recibas postulaciones o calificaciones apareceran aqui.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }
    return Card(
      child: Column(
        children: notifications.map((n) {
          return ListTile(
            leading: const Icon(
              Icons.circle,
              size: 8,
              color: AppColors.pointsPositive,
            ),
            title: Text(
              n.title,
              style: const TextStyle(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(timeAgo(n.createdAt)),
            dense: true,
            onTap: () {
              if (n.relatedRequestId != null) {
                context.push('/requests/${n.relatedRequestId}');
              } else {
                context.push('/notifications');
              }
            },
          );
        }).toList(),
      ),
    );
  }
}

// ============================================================
class _CommunityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(
              'assets/icon_foreground.png',
              height: 56,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sigue creciendo',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Comparte Fixy con otros estudiantes de tu carrera.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
