import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/recipe_details_controller.dart';
import 'package:kitchenary/views/widgets/common/section_title.dart';
import 'package:kitchenary/views/widgets/details/add_to_list_button.dart';
import 'package:kitchenary/views/widgets/details/ingredient_row.dart';
import 'package:kitchenary/views/widgets/details/servings_stepper.dart';
import 'package:provider/provider.dart';

/// The ingredient list, with a servings stepper that rescales the amounts.
///
/// Keep the layout in sync with `RecipeDetailsSkeleton`.
class IngredientSection extends StatelessWidget {
  const IngredientSection({super.key});

  @override
  Widget build(BuildContext context) {
    final details = context.watch<RecipeDetailsController>();
    if (details.recipe.ingredients.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Ingredients'),
        SizedBox(height: 10.h),
        const ServingsStepper(),
        SizedBox(height: 4.h),
        for (final text in details.ingredientTexts) IngredientRow(text: text),
        SizedBox(height: 12.h),
        const AddToListButton(),
        SizedBox(height: 28.h),
      ],
    );
  }
}
