import 'package:flutter/material.dart';

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
        const StatusChip._(label: 'Aprobado', color: Color(0xFF2E7D32)),
      ApplicationStatus.rechazada =>
        const StatusChip._(label: 'Rechazado', color: Color(0xFFC62828)),
      ApplicationStatus.pendiente =>
        const StatusChip._(label: 'Pendiente', color: Color(0xFFE6B800)),
    };
  }

  factory StatusChip.request(RequestStatus status) {
    return switch (status) {
      RequestStatus.abierta =>
        const StatusChip._(label: 'Abierta', color: Color(0xFF1A4CA3)),
      RequestStatus.enRevision =>
        const StatusChip._(label: 'En revision', color: Color(0xFFE6B800)),
      RequestStatus.enProceso =>
        const StatusChip._(label: 'En proceso', color: Color(0xFF057F78)),
      RequestStatus.completada =>
        const StatusChip._(label: 'Completada', color: Color(0xFF2E7D32)),
      RequestStatus.cancelada =>
        const StatusChip._(label: 'Cancelada', color: Color(0xFFC62828)),
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
