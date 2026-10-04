import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/recipe_editor_controller.dart';
import 'package:kitchenary/views/widgets/common/section_title.dart';
import 'package:kitchenary/views/widgets/editor/step_editor_row.dart';
import 'package:provider/provider.dart';

/// The list of method steps with an "Add step" button.
class StepEditor extends StatelessWidget {
  const StepEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<RecipeEditorController>();
    final steps = editor.steps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Method'),
        SizedBox(height: 12.h),
        for (var i = 0; i < steps.length; i++)
          StepEditorRow(key: ValueKey(steps[i].id), step: steps[i], number: i + 1),
        TextButton.icon(
          onPressed: editor.addStep,
          icon: const Icon(Icons.add),
          label: const Text('Add step'),
        ),
      ],
    );
  }
}
