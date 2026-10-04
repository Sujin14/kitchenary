import 'package:flutter/material.dart';
import 'package:kitchenary/views/widgets/home/recipe_card_skeleton.dart';
import 'package:kitchenary/views/widgets/home/recipe_grid_layout.dart';

/// Loading twin of the recipe grid on Home.
class RecipeFeedSkeleton extends StatelessWidget {
  const RecipeFeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: RecipeGridLayout.padding,
      gridDelegate: RecipeGridLayout.delegate,
      itemCount: 6,
      itemBuilder: (context, index) => const RecipeCardSkeleton(),
    );
  }
}
