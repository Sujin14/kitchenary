import 'package:flutter/material.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/diet_type.dart';
import 'package:kitchenary/views/widgets/common/tag_chip.dart';

/// "Vegan" or "Vegetarian" label. Hidden for other diets.
class DietBadge extends StatelessWidget {
  const DietBadge({required this.diet, super.key});

  final DietType diet;

  @override
  Widget build(BuildContext context) {
    if (diet != DietType.vegan && diet != DietType.vegetarian) {
      return const SizedBox.shrink();
    }
    final p = context.palette;
    return TagChip(
      label: diet.label,
      background: p.veganBackground,
      foreground: p.veganForeground,
      icon: Icons.eco_outlined,
    );
  }
}
