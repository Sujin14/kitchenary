import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/views/widgets/editor/diet_selector.dart';
import 'package:kitchenary/views/widgets/editor/editor_save_button.dart';
import 'package:kitchenary/views/widgets/editor/editor_title_field.dart';
import 'package:kitchenary/views/widgets/editor/ingredient_editor.dart';
import 'package:kitchenary/views/widgets/editor/servings_editor.dart';
import 'package:kitchenary/views/widgets/editor/step_editor.dart';

/// The scrollable recipe form.
class RecipeEditorForm extends StatelessWidget {
  const RecipeEditorForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
      children: [
        const EditorTitleField(),
        SizedBox(height: 20.h),
        const DietSelector(),
        SizedBox(height: 20.h),
        const ServingsEditor(),
        SizedBox(height: 28.h),
        const IngredientEditor(),
        SizedBox(height: 20.h),
        const StepEditor(),
        SizedBox(height: 28.h),
        const EditorSaveButton(),
      ],
    );
  }
}
