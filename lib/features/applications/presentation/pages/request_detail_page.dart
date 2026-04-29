import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_error_messages.dart';
import '../../../../core/utils/whatsapp_launcher.dart';
import '../../../../shared/models/applicant_info.dart';
import '../../../../shared/models/application_summary.dart';
import '../../../../shared/models/request_summary.dart';
import '../../../../shared/widgets/medal_badge.dart';
import '../../../../shared/widgets/tag_chip.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../feed/presentation/providers/feed_providers.dart';
import '../../../requests/presentation/providers/requests_providers.dart';
import '../../../requests/presentation/widgets/status_chip.dart';
import '../providers/applications_providers.dart';
import '../widgets/applicant_card.dart';
import '../widgets/apply_sheet.dart';

class RequestDetailPage extends ConsumerWidget {
  const RequestDetailPage({required this.requestId, super.key});
  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(requestDetailProvider(requestId));
    final uid = ref.watch(currentSessionProvider)?.user.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (request) {
          if (request == null) {
            return const Center(child: Text('Solicitud no encontrada'));
          }
          final isCreator = uid == request.creator.id;
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(requestDetailProvider(requestId));
              ref.invalidate(applicantsForRequestProvider(requestId));
              ref.invalidate(myApplicationOnRequestProvider(requestId));
              await ref.read(requestDetailProvider(requestId).future);
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _Header(request: request),
                const SizedBox(height: 20),
                Text(
                  'Descripcion',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(request.description),
                const SizedBox(height: 20),
                if (isCreator)
                  _CreatorView(request: request)
                else
                  _ApplicantView(request: request),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.request});
  final RequestSummary request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProyecto = request.type == RequestType.proyecto;
    final color = isProyecto ? AppColors.primary : AppColors.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isProyecto ? 'Proyecto' : 'Asesoria',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            const Spacer(),
            StatusChip.request(request.status),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          request.title,
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        if (request.tags.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: request.tags.map((t) => TagChip(tag: t)).toList(),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.person_outline, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                request.creator.fullName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            MedalBadge(medal: request.creator.medal, compact: true),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 6,
          children: [
            _MetaItem(icon: Icons.bolt_outlined, text: '+${request.basePoints} pts'),
            _MetaItem(
              icon: Icons.signal_cellular_alt,
              text: 'Dificultad ${request.difficultyLevel}/5',
            ),
            if (request.deadline != null)
              _MetaItem(
                icon: Icons.event_outlined,
                text: 'Vence ${request.deadline!.day}/${request.deadline!.month}',
              ),
            if (request.economicBenefit != null)
              _MetaItem(
                icon: Icons.payments_outlined,
                text: 'S/ ${request.economicBenefit!.toStringAsFixed(2)}',
              ),
            _MetaItem(
              icon: Icons.group_outlined,
              text: '${request.participantsNeeded} participante(s)',
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

// ============================================================
// Vista del CREADOR
// ============================================================
class _CreatorView extends ConsumerWidget {
  const _CreatorView({required this.request});
  final RequestSummary request;

  Future<void> _confirmAndComplete(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Marcar como completada'),
        content: const Text(
          'Una vez completada, ambos podran calificarse y se asignaran puntos. '
          'No se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Completar'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await ref.read(requestsRepositoryProvider).markCompleted(request.id);
      ref.invalidate(requestDetailProvider(request.id));
      ref.invalidate(myCreatedRequestsProvider);
      ref.invalidate(myInProcessProvider);
      ref.invalidate(myCompletedProvider);
      ref.invalidate(feedProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud completada')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authErrorMessage(e))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicantsAsync = ref.watch(applicantsForRequestProvider(request.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (request.status == RequestStatus.enProceso)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FilledButton.icon(
              onPressed: () => _confirmAndComplete(context, ref),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Marcar como completada'),
            ),
          ),
        Text(
          'Postulantes',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        applicantsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('Error: $e'),
          data: (items) {
            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Aun no hay postulantes.'),
              );
            }
            final hasApproved = items.any(
              (a) => a.status == ApplicationStatus.aprobada,
            );
            return Column(
              children: [
                for (final a in items) ...[
                  ApplicantCard(
                    applicant: a,
                    canDecide: !hasApproved &&
                        request.status == RequestStatus.abierta,
                    onApprove: () => _decide(context, ref, a, true),
                    onReject: () => _decide(context, ref, a, false),
                  ),
                  if (a.status == ApplicationStatus.aprobada &&
                      a.whatsappNumber != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OutlinedButton.icon(
                        onPressed: () => openWhatsApp(a.whatsappNumber!),
                        icon: const Icon(Icons.chat),
                        label: Text('WhatsApp ${a.whatsappNumber!}'),
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _decide(
    BuildContext context,
    WidgetRef ref,
    ApplicantInfo applicant,
    bool approve,
  ) async {
    final repo = ref.read(applicationsRepositoryProvider);
    try {
      if (approve) {
        await repo.approve(applicant.applicationId);
      } else {
        await repo.reject(applicant.applicationId);
      }
      ref.invalidate(applicantsForRequestProvider(request.id));
      ref.invalidate(requestDetailProvider(request.id));
      ref.invalidate(myInProcessProvider);
      ref.invalidate(feedProvider);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authErrorMessage(e))),
      );
    }
  }
}

// ============================================================
// Vista del POSTULANTE / VISITANTE
// ============================================================
class _ApplicantView extends ConsumerWidget {
  const _ApplicantView({required this.request});
  final RequestSummary request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAppAsync = ref.watch(myApplicationOnRequestProvider(request.id));

    return myAppAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('Error: $e'),
      data: (myApp) {
        if (myApp == null) {
          // No he postulado todavia.
          if (request.status != RequestStatus.abierta) {
            return _Banner(
              icon: Icons.info_outline,
              text: 'Esta solicitud ya no acepta postulaciones.',
            );
          }
          return FilledButton.icon(
            onPressed: () => ApplySheet.show(context, request.id),
            icon: const Icon(Icons.send_outlined),
            label: const Text('Postularme'),
          );
        }

        // Ya postule. Muestro estado y, si fui aprobado, WhatsApp del creador.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Mi postulacion',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                StatusChip.application(myApp.status),
              ],
            ),
            if (myApp.message != null) ...[
              const SizedBox(height: 8),
              Text(myApp.message!),
            ],
            const SizedBox(height: 16),
            if (myApp.status == ApplicationStatus.aprobada) ...[
              if (request.creator.whatsappNumber != null)
                FilledButton.icon(
                  onPressed: () =>
                      openWhatsApp(request.creator.whatsappNumber!),
                  icon: const Icon(Icons.chat),
                  label: Text(
                    'Abrir WhatsApp ${request.creator.whatsappNumber!}',
                  ),
                )
              else
                _Banner(
                  icon: Icons.info_outline,
                  text:
                      'El creador aun no ha configurado su numero de WhatsApp.',
                ),
            ],
            if (myApp.status == ApplicationStatus.rechazada)
              _Banner(
                icon: Icons.cancel_outlined,
                text:
                    'Tu postulacion fue rechazada. Puedes postularte a otras solicitudes.',
              ),
            if (myApp.status == ApplicationStatus.pendiente)
              _Banner(
                icon: Icons.hourglass_empty,
                text: 'El creador aun no ha tomado una decision.',
              ),
          ],
        );
      },
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: scheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
