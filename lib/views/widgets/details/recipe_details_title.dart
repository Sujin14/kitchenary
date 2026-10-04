import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        SizedBox(height: 6.h),
        Text(
          [
            recipe.sourceLabel,
            if (recipe.category.isNotEmpty) recipe.category,
          ].join(' · '),
          style: context.textTheme.bodyMedium?.copyWith(
            color: p.textSecondary,
          ),
        ),
        SizedBox(height: 14.h),
        RecipeTagRow(recipe: recipe),
      ],
    );
  }
}
