import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/saved_recipes_controller.dart';
import 'package:kitchenary/views/widgets/common/empty_state.dart';
import 'package:kitchenary/views/widgets/home/recipe_grid_layout.dart';
import 'package:kitchenary/views/widgets/recipe/recipe_card.dart';
import 'package:provider/provider.dart';

/// The user's saved recipes as a grid, or a friendly empty state.
class SavedRecipesGrid extends StatelessWidget {
  const SavedRecipesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final saved = context.watch<SavedRecipesController>();
    if (saved.isEmpty) {
      return const EmptyState(
        icon: Icons.favorite_border,
        title: 'Nothing saved yet',
        message: 'Tap the heart on any recipe to keep it here.',
      );
    }
    return GridView.builder(
      padding: RecipeGridLayout.padding,
      gridDelegate: RecipeGridLayout.delegate,
      itemCount: saved.count,
      itemBuilder: (context, index) => RecipeCard(recipe: saved.recipes[index]),
    );
  }
}
