import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/history_controller.dart';
import 'package:kitchenary/controllers/own_recipes_controller.dart';
import 'package:kitchenary/controllers/saved_recipes_controller.dart';
import 'package:kitchenary/controllers/settings_controller.dart';
import 'package:kitchenary/controllers/shopping_list_controller.dart';
import 'package:kitchenary/services/recipe_cache.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:kitchenary/views/widgets/common/confirm_dialog.dart';
import 'package:kitchenary/views/widgets/profile/settings_tile.dart';
import 'package:provider/provider.dart';

/// "Erase my data": removes everything the app stored on this phone.
class EraseDataTile extends StatelessWidget {
  const EraseDataTile({super.key});

  Future<void> _erase(BuildContext context) async {
    final saved = context.read<SavedRecipesController>();
    final history = context.read<HistoryController>();
    final own = context.read<OwnRecipesController>();
    final shopping = context.read<ShoppingListController>();
    final cache = context.read<RecipeCache>();
    final settings = context.read<SettingsController>();

    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Erase all your data?',
      message: 'Your saved recipes, history, own recipes, shopping list, '
          'offline recipes and name will be deleted from this phone. This '
          'cannot be undone.',
      confirmLabel: 'Erase',
    );
    if (!confirmed) return;

    await saved.clear();
    await history.clear();
    await own.clear();
    await shopping.clear();
    await cache.clear();
    await settings.reset();
    if (!context.mounted) return;
    AppSnackBar.show(context, 'Your data was erased');
  }

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: Icons.delete_outline,
      title: 'Erase my data',
      subtitle: 'Saved, history, own recipes, shopping list and name',
      destructive: true,
      onTap: () => _erase(context),
    );
  }
}
