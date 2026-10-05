import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/recipe_details_controller.dart';
import 'package:kitchenary/controllers/shopping_list_controller.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:kitchenary/views/widgets/common/secondary_button.dart';
import 'package:provider/provider.dart';

/// Puts the ingredients, at the chosen servings, on the shopping list.
///
/// Keep the height in sync with `RecipeDetailsSkeleton`.
class AddToListButton extends StatelessWidget {
  const AddToListButton({super.key});

  static double get height => 52.h;

  Future<void> _add(BuildContext context) async {
    final details = context.read<RecipeDetailsController>();
    final list = context.read<ShoppingListController>();
    final factor = details.scaleFactor;
    final result = await list.addIngredients(
      [
        for (final item in details.recipe.ingredients)
          RecipeIngredient(
            name: item.name,
            measure: item.scaledMeasure(factor),
          ),
      ],
      recipeTitle: details.recipe.title,
    );
    if (!context.mounted) return;
    final message = result.added == 0
        ? 'Everything is already on your list'
        : result.skipped == 0
            ? 'Added ${result.added} to your shopping list'
            : 'Added ${result.added}, ${result.skipped} already on your list';
    AppSnackBar.show(
      context,
      message,
      actionLabel: 'Order now',
      onAction: () {
        if (context.mounted) context.openOrder();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: SecondaryButton(
        label: 'Add to shopping list',
        icon: Icons.add_shopping_cart,
        onPressed: () => _add(context),
      ),
    );
  }
}
