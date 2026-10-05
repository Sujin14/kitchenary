import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/cooking_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/views/widgets/cooking/add_timer_sheet.dart';
import 'package:kitchenary/views/widgets/cooking/cooking_progress_bar.dart';
import 'package:provider/provider.dart';

/// Close button, recipe name, where you are, and the progress bar.
class CookingTopBar extends StatelessWidget {
  const CookingTopBar({super.key});

  String _where(CookingController cooking) {
    if (cooking.isIngredientsPage) return 'Ingredients';
    if (cooking.isDonePage) return 'Done';
    return 'Step ${cooking.stepNumber} of ${cooking.stepCount}';
  }

  @override
  Widget build(BuildContext context) {
    final cooking = context.watch<CookingController>();
    final p = context.palette;
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 20.w, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Close cooking mode',
                iconSize: 28.sp,
                color: p.cookingText,
                icon: const Icon(Icons.close),
                onPressed: () => context.popOrHome(),
              ),
              Expanded(
                child: Text(
                  cooking.recipe.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: p.cookingText,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Start a timer',
                iconSize: 26.sp,
                color: p.cookingText,
                icon: const Icon(Icons.timer_outlined),
                onPressed: () => showAddTimerSheet(
                  context,
                  cooking.recipe.title,
                  stepNumber: cooking.isStepPage ? cooking.stepNumber : null,
                  stepText: cooking.isStepPage
                      ? cooking.steps[cooking.stepNumber - 1]
                      : null,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                _where(cooking),
                style: context.textTheme.titleSmall?.copyWith(
                  color: p.cookingAccent,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: CookingProgressBar(progress: cooking.progress),
          ),
        ],
      ),
    );
  }
}
