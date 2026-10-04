import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/recipe_editor_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/diet_type.dart';
import 'package:provider/provider.dart';

/// Choose Veg, Non-veg or Vegan for the recipe being written.
class DietSelector extends StatelessWidget {
  const DietSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<RecipeEditorController>();
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type',
          style: context.textTheme.labelMedium?.copyWith(
            color: p.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<DietType>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: DietType.vegetarian, label: Text('Veg')),
              ButtonSegment(value: DietType.nonVeg, label: Text('Non-veg')),
              ButtonSegment(value: DietType.vegan, label: Text('Vegan')),
            ],
            selected: {editor.diet},
            onSelectionChanged: (selection) =>
                editor.setDiet(selection.first),
          ),
        ),
      ],
    );
  }
}
