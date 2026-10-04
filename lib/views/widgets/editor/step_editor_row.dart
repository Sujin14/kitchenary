import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/recipe_editor_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/draft_line.dart';
import 'package:provider/provider.dart';

/// One method step: its number, a multi-line field and a remove button.
class StepEditorRow extends StatelessWidget {
  const StepEditorRow({required this.step, required this.number, super.key});

  final DraftLine step;
  final int number;

  @override
  Widget build(BuildContext context) {
    final editor = context.read<RecipeEditorController>();
    final p = context.palette;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            margin: EdgeInsets.only(top: 12.h, right: 10.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: p.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: context.textTheme.labelMedium?.copyWith(color: p.primary),
            ),
          ),
          Expanded(
            child: TextFormField(
              initialValue: step.text,
              minLines: 2,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Describe this step',
              ),
              onChanged: (value) => editor.setStep(step.id, value),
            ),
          ),
          IconButton(
            tooltip: 'Remove step',
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => editor.removeStep(step.id),
          ),
        ],
      ),
    );
  }
}
