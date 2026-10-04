import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/own_recipes_controller.dart';
import 'package:kitchenary/controllers/recipe_editor_controller.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:kitchenary/views/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

/// Validates the draft and stores it as one of the user's own recipes.
class EditorSaveButton extends StatelessWidget {
  const EditorSaveButton({super.key});

  Future<void> _save(BuildContext context) async {
    final editor = context.read<RecipeEditorController>();
    final own = context.read<OwnRecipesController>();

    final problem = editor.problem;
    if (problem != null) {
      AppSnackBar.show(context, problem);
      return;
    }

    await own.upsert(editor.build(own.newId()));
    if (!context.mounted) return;
    AppSnackBar.show(context, 'Recipe saved');
    context.popOrHome();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: 'Save recipe',
      icon: Icons.check,
      onPressed: () => _save(context),
    );
  }
}
