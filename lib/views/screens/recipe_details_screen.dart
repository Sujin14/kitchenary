import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/history_controller.dart';
import 'package:kitchenary/controllers/recipe_details_controller.dart';
import 'package:kitchenary/controllers/saved_recipes_controller.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/services/recipe_service.dart';
import 'package:kitchenary/views/widgets/details/recipe_details_body.dart';
import 'package:provider/provider.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeDetailsController>(
      create: (context) {
        final history = context.read<HistoryController>();
        final saved = context.read<SavedRecipesController>();
        return RecipeDetailsController(
          context.read<RecipeService>(),
          recipe,
          // Once the full recipe is ready: add it to the history, and
          // upgrade the saved copy so it opens complete later.
          onLoaded: (full) {
            history.record(full);
            saved.refresh(full);
          },
        );
      },
      child: const Scaffold(body: RecipeDetailsBody()),
    );
  }
}
