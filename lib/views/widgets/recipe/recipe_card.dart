import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/widgets/common/app_card.dart';
import 'package:kitchenary/views/widgets/common/diet_mark.dart';
import 'package:kitchenary/views/widgets/common/recipe_image.dart';
import 'package:kitchenary/views/widgets/recipe/save_recipe_button.dart';

/// A grid card: photo, veg / non-veg mark and title. Opens the details screen.
///
/// Keep the layout in sync with `RecipeCardSkeleton`.
class RecipeCard extends StatelessWidget {
  const RecipeCard({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.openRecipe(recipe),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                RecipeImage(url: recipe.imageUrl),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: DietMark(diet: recipe.diet),
                ),
                Positioned(
                  top: 6.h,
                  right: 6.w,
                  child: SaveRecipeButton(recipe: recipe, compact: true),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Text(
              recipe.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
