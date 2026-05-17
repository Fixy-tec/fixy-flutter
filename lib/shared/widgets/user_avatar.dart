import 'package:flutter/material.dart';

import '../../core/constants/avatars.dart';

/// Avatar circular del usuario. Si tiene avatarSlug muestra el PNG
/// de la mascota Fixo elegida; si no, muestra iniciales como fallback.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.fullName,
    this.avatarSlug,
    this.radius = 20,
    this.fontSize,
    super.key,
  });

  final String fullName;
  final String? avatarSlug;
  final double radius;
  final double? fontSize;

  String get _initials {
    return fullName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final asset = avatarAssetFor(avatarSlug);

    if (asset == null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: scheme.primaryContainer,
        child: Text(
          _initials,
          style: TextStyle(
            fontSize: fontSize ?? radius * 0.7,
            fontWeight: FontWeight.w700,
            color: scheme.onPrimaryContainer,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.surfaceContainerHighest,
      backgroundImage: AssetImage(asset),
    );
  }
}
