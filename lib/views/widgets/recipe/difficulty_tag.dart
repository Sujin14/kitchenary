import 'package:flutter/material.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/difficulty.dart';
import 'package:kitchenary/views/widgets/common/tag_chip.dart';

/// Green (easy), yellow (medium) or red (hard).
class DifficultyTag extends StatelessWidget {
  const DifficultyTag({required this.difficulty, super.key});

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final (Color bg, Color fg) = switch (difficulty) {
      Difficulty.easy => (p.easyBackground, p.easyForeground),
      Difficulty.medium => (p.mediumBackground, p.mediumForeground),
      Difficulty.hard => (p.hardBackground, p.hardForeground),
    };
    return TagChip(
      label: difficulty.label,
      background: bg,
      foreground: fg,
      icon: Icons.speed,
    );
  }
}
