import 'package:flutter/material.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/diet_type.dart';

/// The Indian veg / non-veg symbol: a square outline with a coloured dot.
/// Renders nothing when the diet is unknown.
class DietMark extends StatelessWidget {
  const DietMark({required this.diet, this.size = 18, super.key});

  final DietType diet;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (diet == DietType.unknown) return const SizedBox.shrink();
    final p = context.palette;
    final color = diet.isVeg ? p.vegMark : p.nonVegMark;
    return Semantics(
      label: diet.isVeg ? 'Vegetarian' : 'Non-vegetarian',
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * 0.2),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color, width: 1.6),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
