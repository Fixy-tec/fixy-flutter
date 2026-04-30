import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/models/applicant_info.dart';
import '../../../../shared/models/application_summary.dart';
import '../../../../shared/widgets/medal_badge.dart';
import '../../../requests/presentation/widgets/status_chip.dart';

class ApplicantCard extends StatelessWidget {
  const ApplicantCard({
    required this.applicant,
    required this.onApprove,
    required this.onReject,
    this.canDecide = true,
    super.key,
  });

  final ApplicantInfo applicant;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final bool canDecide;

  @override
  Widget build(BuildContext context) {
    final initials = applicant.fullName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
    final isPending = applicant.status == ApplicationStatus.pendiente;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/users/${applicant.applicantId}'),
        child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicant.fullName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${applicant.totalPoints} pts · '
                        '${applicant.ratingsCount == 0 ? "Sin calificaciones" : "★ ${applicant.avgRating.toStringAsFixed(1)} (${applicant.ratingsCount})"}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MedalBadge(medal: applicant.medal, compact: true),
                    const SizedBox(height: 4),
                    StatusChip.application(applicant.status),
                  ],
                ),
              ],
            ),
            if (applicant.message != null && applicant.message!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                applicant.message!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (canDecide && isPending) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReject,
                      child: const Text('Rechazar'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: onApprove,
                      child: const Text('Aceptar'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }
}
