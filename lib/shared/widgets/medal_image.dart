import 'package:flutter/material.dart';

import '../../core/constants/reputation.dart';

/// Imagen circular de la medalla. Usa los PNGs en assets/medals/.
class MedalImage extends StatelessWidget {
  const MedalImage({required this.medal, this.size = 64, super.key});

  final Medal medal;
  final double size;

  String get _asset => 'assets/medals/${medal.name}.png';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(_asset, fit: BoxFit.contain),
    );
  }
}
