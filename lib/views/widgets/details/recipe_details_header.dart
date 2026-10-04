import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/widgets/common/circle_icon_button.dart';
import 'package:kitchenary/views/widgets/common/diet_mark.dart';
import 'package:kitchenary/views/widgets/common/recipe_image.dart';
import 'package:kitchenary/views/widgets/recipe/save_recipe_button.dart';

/// Hero photo with back and save buttons and the veg / non-veg mark.
class RecipeDetailsHeader extends StatelessWidget {
  const RecipeDetailsHeader({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final height = 320.h;
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RecipeImage(url: recipe.imageUrl, height: height),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8.h,
            left: 12.w,
            child: CircleIconButton(
              icon: Icons.arrow_back,
              tooltip: 'Back',
              onPressed: () => context.popOrHome(),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8.h,
            right: 12.w,
            child: SaveRecipeButton(recipe: recipe),
          ),
          Positioned(
            bottom: 12.h,
            left: 16.w,
            child: DietMark(diet: recipe.diet, size: 22.r),
          ),
        ],
      ),
    );
  }
}
