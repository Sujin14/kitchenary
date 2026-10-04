import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/own_recipes_controller.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/views/widgets/common/empty_state.dart';
import 'package:kitchenary/views/widgets/common/primary_button.dart';
import 'package:kitchenary/views/widgets/mine/own_recipe_menu.dart';
import 'package:kitchenary/views/widgets/recipe/recipe_list_tile.dart';
import 'package:provider/provider.dart';

/// The recipes the user wrote, or an invitation to write the first one.
class OwnRecipesList extends StatelessWidget {
  const OwnRecipesList({super.key});

  @override
  Widget build(BuildContext context) {
    final own = context.watch<OwnRecipesController>();
    if (own.isEmpty) {
      return EmptyState(
        icon: Icons.menu_book_outlined,
        title: 'No recipes of your own yet',
        message: 'Write down family favourites so they are always at hand.',
        action: PrimaryButton(
          label: 'Write a recipe',
          icon: Icons.add,
          onPressed: () => context.openRecipeEditor(),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
      itemCount: own.count,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final recipe = own.recipes[index];
        return RecipeListTile(
          recipe: recipe,
          trailing: OwnRecipeMenu(recipe: recipe),
        );
      },
    );
  }
}
