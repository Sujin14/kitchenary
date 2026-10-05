import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/recipe_details_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/views/widgets/common/count_stepper.dart';
import 'package:provider/provider.dart';

/// "Servings  - 4 +": changes the amounts shown in the ingredient list.
///
/// Keep the height in sync with `RecipeDetailsSkeleton`.
class ServingsStepper extends StatelessWidget {
  const ServingsStepper({super.key});

  static double get height => 48.r;

  @override
  Widget build(BuildContext context) {
    final details = context.watch<RecipeDetailsController>();
    final p = context.palette;
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Icon(Icons.people_outline, color: p.primary),
          SizedBox(width: 10.w),
          Expanded(
            child: Text('Servings', style: context.textTheme.bodyLarge),
          ),
          CountStepper(
            value: details.servings,
            min: RecipeDetailsController.minServings,
            max: RecipeDetailsController.maxServings,
            onChanged: details.setServings,
            decreaseLabel: 'Fewer servings',
            increaseLabel: 'More servings',
          ),
        ],
      ),
    );
  }
}
