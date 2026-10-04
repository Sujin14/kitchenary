import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/recipe_editor_controller.dart';
import 'package:kitchenary/views/widgets/common/section_title.dart';
import 'package:kitchenary/views/widgets/editor/ingredient_editor_row.dart';
import 'package:provider/provider.dart';

/// The list of ingredient rows with an "Add ingredient" button.
class IngredientEditor extends StatelessWidget {
  const IngredientEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<RecipeEditorController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Ingredients'),
        SizedBox(height: 12.h),
        for (final ingredient in editor.ingredients)
          IngredientEditorRow(
            key: ValueKey(ingredient.id),
            ingredient: ingredient,
          ),
        TextButton.icon(
          onPressed: editor.addIngredient,
          icon: const Icon(Icons.add),
          label: const Text('Add ingredient'),
        ),
      ],
    );
  }
}
