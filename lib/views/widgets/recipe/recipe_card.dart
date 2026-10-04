import 'package:flutter/material.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/navigation/app_routes.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/widgets/common/app_card.dart';
import 'package:kitchenary/views/widgets/common/diet_mark.dart';
import 'package:kitchenary/views/widgets/common/recipe_image.dart';

/// A grid card: photo, veg / non-veg mark and title. Opens the details screen.
class RecipeCard extends StatelessWidget {
  const RecipeCard({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.pushNamed<void>(
        AppRoutes.recipeDetails,
        arguments: recipe,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                RecipeImage(url: recipe.imageUrl),
                Positioned(
                  top: 8,
                  left: 8,
                  child: DietMark(diet: recipe.diet),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
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
