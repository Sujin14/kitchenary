import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/home_controller.dart';
import 'package:kitchenary/controllers/load_status.dart';
import 'package:kitchenary/views/widgets/common/empty_state.dart';
import 'package:kitchenary/views/widgets/common/error_state.dart';
import 'package:kitchenary/views/widgets/home/recipe_feed_skeleton.dart';
import 'package:kitchenary/views/widgets/home/recipe_grid_layout.dart';
import 'package:kitchenary/views/widgets/recipe/recipe_card.dart';
import 'package:provider/provider.dart';

/// The grid of recipes, with shimmer loading, error and empty states.
class RecipeFeed extends StatelessWidget {
  const RecipeFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeController>();

    switch (home.status) {
      case LoadStatus.idle:
      case LoadStatus.loading:
        return const RecipeFeedSkeleton();
      case LoadStatus.error:
        return ErrorState(message: home.errorMessage, onRetry: home.retry);
      case LoadStatus.success:
        if (home.recipes.isEmpty) {
          return EmptyState(
            icon: Icons.search_off,
            title: 'No recipes found',
            message: home.isSearching
                ? 'Try another word, or browse the categories above.'
                : 'Nothing here yet. Try a different chip.',
          );
        }
        return GridView.builder(
          padding: RecipeGridLayout.padding,
          gridDelegate: RecipeGridLayout.delegate,
          itemCount: home.recipes.length,
          itemBuilder: (context, index) =>
              RecipeCard(recipe: home.recipes[index]),
        );
    }
  }
}
