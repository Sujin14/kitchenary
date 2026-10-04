import 'package:flutter/material.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';

/// One ingredient with a bullet.
class IngredientRow extends StatelessWidget {
  const IngredientRow({required this.ingredient, super.key});

  final RecipeIngredient ingredient;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Icon(Icons.circle, size: 7, color: p.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient.displayText,
              style: context.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
