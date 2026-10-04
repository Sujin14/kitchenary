import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/widgets/recipe/diet_badge.dart';
import 'package:kitchenary/views/widgets/recipe/difficulty_tag.dart';

/// The colour-coded metadata tags of a recipe.
class RecipeTagRow extends StatelessWidget {
  const RecipeTagRow({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        if (!recipe.isSummary) DifficultyTag(difficulty: recipe.difficulty),
        DietBadge(diet: recipe.diet),
      ],
    );
  }
}
