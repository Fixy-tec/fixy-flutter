import 'package:flutter/material.dart';

import '../models/tag.dart';

class TagChip extends StatelessWidget {
  const TagChip({required this.tag, this.dense = true, super.key});

  final Tag tag;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 10 : 12,
        vertical: dense ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        tag.name,
        style: TextStyle(
          fontSize: dense ? 11 : 13,
          fontWeight: FontWeight.w500,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}
