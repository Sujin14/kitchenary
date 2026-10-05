import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/recipe_editor_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/views/widgets/common/count_stepper.dart';
import 'package:provider/provider.dart';

/// How many people the amounts in this recipe feed. The servings stepper on
/// the details screen scales from this number.
class ServingsEditor extends StatelessWidget {
  const ServingsEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<RecipeEditorController>();
    final p = context.palette;
    return Row(
      children: [
        Icon(Icons.people_outline, color: p.primary),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            'Amounts are for how many people?',
            style: context.textTheme.bodyMedium,
          ),
        ),
        CountStepper(
          value: editor.servings,
          min: RecipeEditorController.minServings,
          max: RecipeEditorController.maxServings,
          onChanged: editor.setServings,
          decreaseLabel: 'Fewer servings',
          increaseLabel: 'More servings',
        ),
      ],
    );
  }
}
