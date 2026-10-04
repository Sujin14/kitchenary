import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/own_recipes_controller.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:kitchenary/views/widgets/common/confirm_dialog.dart';
import 'package:provider/provider.dart';

enum _OwnRecipeAction { edit, delete }

/// The "..." menu on one of the user's own recipes: edit or delete.
class OwnRecipeMenu extends StatelessWidget {
  const OwnRecipeMenu({required this.recipe, super.key});

  final Recipe recipe;

  Future<void> _delete(BuildContext context) async {
    final own = context.read<OwnRecipesController>();
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete this recipe?',
      message: '"${recipe.title}" will be removed from this phone.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) return;
    await own.delete(recipe.id);
    if (!context.mounted) return;
    AppSnackBar.show(context, 'Recipe deleted');
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_OwnRecipeAction>(
      tooltip: 'Recipe options',
      onSelected: (action) {
        switch (action) {
          case _OwnRecipeAction.edit:
            context.openRecipeEditor(recipe);
          case _OwnRecipeAction.delete:
            _delete(context);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: _OwnRecipeAction.edit, child: Text('Edit')),
        PopupMenuItem(value: _OwnRecipeAction.delete, child: Text('Delete')),
      ],
    );
  }
}
