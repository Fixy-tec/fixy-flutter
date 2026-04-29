import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../models/request_summary.dart';
import 'medal_badge.dart';
import 'tag_chip.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({required this.request, this.onTap, super.key});

  final RequestSummary request;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProyecto = request.type == RequestType.proyecto;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _TypeBadge(isProyecto: isProyecto),
                  const Spacer(),
                  Text(
                    '+${request.basePoints} pts',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.lightGreenAccent.shade400,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                request.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (request.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      request.tags.map((t) => TagChip(tag: t)).toList(),
                ),
              ],
              const SizedBox(height: 12),
              _CreatorRow(request: request),
              const SizedBox(height: 8),
              _FooterMeta(request: request),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.isProyecto});
  final bool isProyecto;

  @override
  Widget build(BuildContext context) {
    final color = isProyecto ? AppColors.primary : AppColors.secondary;
    final label = isProyecto ? 'Proyecto' : 'Asesoria';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _CreatorRow extends StatelessWidget {
  const _CreatorRow({required this.request});
  final RequestSummary request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = request.creator.fullName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            initials,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            request.creator.fullName,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        MedalBadge(medal: request.creator.medal, compact: true),
        if (request.economicBenefit != null) ...[
          const SizedBox(width: 8),
          Text(
            '· S/ ${request.economicBenefit!.toStringAsFixed(2)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.lightGreenAccent.shade400,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _FooterMeta extends StatelessWidget {
  const _FooterMeta({required this.request});
  final RequestSummary request;

  String _deadlineText() {
    if (request.deadline == null) return 'Sin fecha limite';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = request.deadline!.difference(today).inDays;
    if (diff < 0) return 'Vencido';
    if (diff == 0) return 'Vence hoy';
    if (diff == 1) return 'Vence manana';
    return 'Vence en $diff dias';
  }

  @override
  Widget build(BuildContext context) {
    final hint = Theme.of(context).colorScheme.onSurfaceVariant;
    final postulantes = request.applicationsCount == 1
        ? '1 postulante'
        : '${request.applicationsCount} postulantes';

    return Text(
      '${_deadlineText()} · $postulantes',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: hint),
    );
  }
}

/// Helper publico para formato de fecha (otras pantallas).
String formatRelativeDate(DateTime date) {
  return DateFormat('d MMM', 'es').format(date);
}
