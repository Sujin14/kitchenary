import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/load_status.dart';
import 'package:kitchenary/controllers/recipe_details_controller.dart';
import 'package:kitchenary/views/widgets/common/error_state.dart';
import 'package:kitchenary/views/widgets/common/loading_indicator.dart';
import 'package:kitchenary/views/widgets/details/ingredient_section.dart';
import 'package:kitchenary/views/widgets/details/instruction_section.dart';
import 'package:kitchenary/views/widgets/details/recipe_details_header.dart';
import 'package:kitchenary/views/widgets/details/recipe_details_title.dart';
import 'package:kitchenary/views/widgets/details/video_link_button.dart';
import 'package:provider/provider.dart';

/// Scrollable content of the recipe details screen.
class RecipeDetailsBody extends StatelessWidget {
  const RecipeDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final details = context.watch<RecipeDetailsController>();
    final recipe = details.recipe;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecipeDetailsHeader(recipe: recipe),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: _content(details),
          ),
        ],
      ),
    );
  }

  Widget _content(RecipeDetailsController details) {
    final recipe = details.recipe;
    switch (details.status) {
      case LoadStatus.idle:
      case LoadStatus.loading:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecipeDetailsTitle(recipe: recipe),
            const LoadingIndicator(),
          ],
        );
      case LoadStatus.error:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecipeDetailsTitle(recipe: recipe),
            ErrorState(message: details.errorMessage, onRetry: details.load),
          ],
        );
      case LoadStatus.success:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecipeDetailsTitle(recipe: recipe),
            const SizedBox(height: 28),
            IngredientSection(recipe: recipe),
            InstructionSection(recipe: recipe),
            VideoLinkButton(recipe: recipe),
          ],
        );
    }
  }
}
