import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/cooking_controller.dart';
import 'package:kitchenary/controllers/timers_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/utils/duration_format.dart';
import 'package:kitchenary/core/utils/step_duration_parser.dart';
import 'package:provider/provider.dart';

/// One "Start 10 min timer" button per time mentioned in the step.
class StepTimerButtons extends StatelessWidget {
  const StepTimerButtons({
    required this.stepNumber,
    required this.stepText,
    super.key,
  });

  final int stepNumber;
  final String stepText;

  @override
  Widget build(BuildContext context) {
    final found = StepDurationParser.find(stepText);
    if (found.isEmpty) return const SizedBox.shrink();
    final p = context.palette;

    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: [
          for (final item in found)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: p.cookingAccent,
                side: BorderSide(color: p.cookingAccent, width: 1.5),
                minimumSize: Size(0, 52.h),
                padding: EdgeInsets.symmetric(horizontal: 18.w),
              ),
              icon: const Icon(Icons.timer_outlined),
              label: Text('Start ${DurationFormat.words(item.duration)} timer'),
              onPressed: () {
                context.read<TimersController>().start(
                      recipeTitle: context.read<CookingController>().recipe.title,
                      label: 'Step $stepNumber',
                      duration: item.duration,
                    );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        '${DurationFormat.words(item.duration)} timer started',
                      ),
                    ),
                  );
              },
            ),
        ],
      ),
    );
  }
}
