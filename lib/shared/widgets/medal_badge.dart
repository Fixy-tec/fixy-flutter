import 'package:flutter/material.dart';

import '../../core/constants/reputation.dart';
import '../../core/theme/app_colors.dart';

class MedalBadge extends StatelessWidget {
  const MedalBadge({required this.medal, this.compact = false, super.key});

  final Medal medal;
  final bool compact;

  Color get _color => switch (medal) {
        Medal.hierro => AppColors.medalHierro,
        Medal.bronce => AppColors.medalBronce,
        Medal.plata => AppColors.medalPlata,
        Medal.oro => AppColors.medalOro,
        Medal.diamante => AppColors.medalDiamante,
        Medal.maestro => AppColors.medalMaestro,
        Medal.challenger => AppColors.medalChallenger,
      };

  String get _label => switch (medal) {
        Medal.hierro => 'Hierro',
        Medal.bronce => 'Bronce',
        Medal.plata => 'Plata',
        Medal.oro => 'Oro',
        Medal.diamante => 'Diamante',
        Medal.maestro => 'Maestro',
        Medal.challenger => 'Challenger',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, size: compact ? 12 : 14, color: _color),
          const SizedBox(width: 4),
          Text(
            _label,
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}
