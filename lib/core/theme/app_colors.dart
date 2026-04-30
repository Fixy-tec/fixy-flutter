import 'package:flutter/material.dart';

/// Paleta brand de Fixy. Todos los colores no provistos por el ColorScheme
/// de Material 3 viven aqui (medallas, estados de solicitud, deltas de puntos,
/// montos en soles).
class AppColors {
  AppColors._();

  // -------- Brand --------
  static const Color primary = Color(0xFF1A4CA3);
  static const Color secondary = Color(0xFF057F78);

  // Verde Fixy (derivado del secondary). Para puntos positivos y montos.
  static const Color pointsPositive = Color(0xFF34A29B);
  // Rojo apagado para deltas negativos / penalizaciones.
  static const Color pointsNegative = Color(0xFFD64545);
  // Ambar para advertencias y "pendiente".
  static const Color warning = Color(0xFFE6B800);

  // -------- Medallas (estilo LoL) --------
  static const Color medalHierro = Color(0xFF6B6B6B);
  static const Color medalBronce = Color(0xFFB07A4A);
  static const Color medalPlata = Color(0xFFB8C0CC);
  static const Color medalOro = Color(0xFFE6B800);
  static const Color medalDiamante = Color(0xFF4FC3F7);
  static const Color medalMaestro = Color(0xFFAB47BC);
  static const Color medalChallenger = Color(0xFFFF5252);

  // -------- Estados de solicitud / postulacion --------
  // (alias semanticos sobre los brand)
  static const Color statusOpen = primary;
  static const Color statusInReview = warning;
  static const Color statusInProcess = secondary;
  static const Color statusCompleted = Color(0xFF2E7D32);
  static const Color statusRejected = Color(0xFFC62828);
  static const Color statusApproved = statusCompleted;
  static const Color statusPending = warning;
}
