import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/application_summary.dart';
import '../../../../shared/models/request_summary.dart';

/// Chip de estado para mostrar en cards de Mis Solicitudes.
class StatusChip extends StatelessWidget {
  const StatusChip._({required this.label, required this.color});

  final String label;
  final Color color;

  factory StatusChip.application(ApplicationStatus status) {
    return switch (status) {
      ApplicationStatus.aprobada =>
        const StatusChip._(label: 'Aprobado', color: AppColors.statusApproved),
      ApplicationStatus.rechazada =>
        const StatusChip._(label: 'Rechazado', color: AppColors.statusRejected),
      ApplicationStatus.pendiente =>
        const StatusChip._(label: 'Pendiente', color: AppColors.statusPending),
    };
  }

  factory StatusChip.request(RequestStatus status) {
    return switch (status) {
      RequestStatus.abierta =>
        const StatusChip._(label: 'Abierta', color: AppColors.statusOpen),
      RequestStatus.enRevision =>
        const StatusChip._(label: 'En revision', color: AppColors.statusInReview),
      RequestStatus.enProceso =>
        const StatusChip._(label: 'En proceso', color: AppColors.statusInProcess),
      RequestStatus.completada =>
        const StatusChip._(label: 'Completada', color: AppColors.statusCompleted),
      RequestStatus.cancelada =>
        const StatusChip._(label: 'Cancelada', color: AppColors.statusRejected),
    };
  }

  @override
  Widget build(BuildContext context) {
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
