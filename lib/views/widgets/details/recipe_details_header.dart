import 'package:flutter/material.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/widgets/common/circle_icon_button.dart';
import 'package:kitchenary/views/widgets/common/diet_mark.dart';
import 'package:kitchenary/views/widgets/common/recipe_image.dart';

/// Hero photo with a back button and the veg / non-veg mark.
class RecipeDetailsHeader extends StatelessWidget {
  const RecipeDetailsHeader({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RecipeImage(url: recipe.imageUrl, height: 320),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: 12,
            child: CircleIconButton(
              icon: Icons.arrow_back,
              tooltip: 'Back',
              onPressed: () => context.pop(),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 16,
            child: DietMark(diet: recipe.diet, size: 22),
          ),
        ],
      ),
    );
  }
}
