import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/widgets/common/section_title.dart';
import 'package:kitchenary/views/widgets/details/ingredient_row.dart';

/// The ingredient list.
class IngredientSection extends StatelessWidget {
  const IngredientSection({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    if (recipe.ingredients.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Ingredients'),
        SizedBox(height: 10.h),
        for (final ingredient in recipe.ingredients)
          IngredientRow(ingredient: ingredient),
        SizedBox(height: 28.h),
      ],
    );
  }
}
