import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';

/// One ingredient with a bullet.
///
/// Keep the layout in sync with `IngredientRowSkeleton`.
class IngredientRow extends StatelessWidget {
  const IngredientRow({required this.ingredient, super.key});

  final RecipeIngredient ingredient;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Icon(Icons.circle, size: 7.r, color: p.accent),
          ),
          SizedBox(width: 12.w),
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
