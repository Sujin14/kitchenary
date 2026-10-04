import 'package:flutter/material.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/widgets/recipe/recipe_tag_row.dart';

/// Recipe name, cuisine and metadata tags.
class RecipeDetailsTitle extends StatelessWidget {
  const RecipeDetailsTitle({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(recipe.title, style: context.textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(
          [
            recipe.sourceLabel,
            if (recipe.category.isNotEmpty) recipe.category,
          ].join(' · '),
          style: context.textTheme.bodyMedium?.copyWith(
            color: p.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        RecipeTagRow(recipe: recipe),
      ],
    );
  }
}
