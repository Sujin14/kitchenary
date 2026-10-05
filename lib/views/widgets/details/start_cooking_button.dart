import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/recipe_details_controller.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/models/cooking_session.dart';
import 'package:kitchenary/views/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

/// Opens step-by-step cooking mode (hidden when there is no method).
class StartCookingButton extends StatelessWidget {
  const StartCookingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final details = context.watch<RecipeDetailsController>();
    if (!details.recipe.hasSteps) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: PrimaryButton(
        label: 'Start cooking',
        icon: Icons.play_arrow_rounded,
        onPressed: () => context.openCooking(
          CookingSession(
            recipe: details.recipe,
            servings: details.servings,
          ),
        ),
      ),
    );
  }
}
