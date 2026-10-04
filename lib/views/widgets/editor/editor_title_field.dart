import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/recipe_editor_controller.dart';
import 'package:provider/provider.dart';

/// "Recipe name" text field.
class EditorTitleField extends StatelessWidget {
  const EditorTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.read<RecipeEditorController>();
    return TextFormField(
      initialValue: editor.title,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Recipe name',
        hintText: 'e.g. Aloo gobi',
      ),
      onChanged: editor.setTitle,
    );
  }
}
