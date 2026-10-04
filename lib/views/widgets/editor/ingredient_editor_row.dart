import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/recipe_editor_controller.dart';
import 'package:kitchenary/models/draft_line.dart';
import 'package:provider/provider.dart';

/// One ingredient: amount, name and a remove button.
class IngredientEditorRow extends StatelessWidget {
  const IngredientEditorRow({required this.ingredient, super.key});

  final DraftIngredient ingredient;

  @override
  Widget build(BuildContext context) {
    final editor = context.read<RecipeEditorController>();
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: ingredient.measure,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: '200 g'),
              onChanged: (value) =>
                  editor.setIngredientMeasure(ingredient.id, value),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: ingredient.name,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: 'Paneer'),
              onChanged: (value) =>
                  editor.setIngredientName(ingredient.id, value),
            ),
          ),
          IconButton(
            tooltip: 'Remove ingredient',
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => editor.removeIngredient(ingredient.id),
          ),
        ],
      ),
    );
  }
}
