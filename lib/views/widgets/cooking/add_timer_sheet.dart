import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/timers_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/utils/duration_format.dart';
import 'package:kitchenary/core/utils/step_duration_parser.dart';
import 'package:provider/provider.dart';

/// Opens the quick-timer sheet.
Future<void> showAddTimerSheet(
  BuildContext context,
  String recipeTitle, {
  int? stepNumber,
  String? stepText,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => AddTimerSheet(
      recipeTitle: recipeTitle,
      stepNumber: stepNumber,
      stepText: stepText,
    ),
  );
}

/// Preset times for a timer that is not tied to a step.
class AddTimerSheet extends StatelessWidget {
  const AddTimerSheet({
    required this.recipeTitle,
    this.stepNumber,
    this.stepText,
    super.key,
  });

  final String recipeTitle;

  /// When opened on a step, the times mentioned in it are offered first.
  final int? stepNumber;
  final String? stepText;

  static const List<int> presetMinutes = [1, 5, 10, 15, 20, 30, 45, 60];

  @override
  Widget build(BuildContext context) {
    final fromStep = stepText == null
        ? const <DetectedDuration>[]
        : StepDurationParser.find(stepText!);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start a timer', style: context.textTheme.titleLarge),
            SizedBox(height: 16.h),
            if (fromStep.isNotEmpty) ...[
              Text('From this step', style: context.textTheme.titleSmall),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: [
                  for (final item in fromStep)
                    ActionChip(
                      avatar: const Icon(Icons.timer_outlined),
                      label: Text(DurationFormat.words(item.duration)),
                      onPressed: () {
                        context.read<TimersController>().start(
                              recipeTitle: recipeTitle,
                              label: 'Step $stepNumber',
                              duration: item.duration,
                            );
                        Navigator.of(context).pop();
                      },
                    ),
                ],
              ),
              SizedBox(height: 20.h),
              Text('Other times', style: context.textTheme.titleSmall),
              SizedBox(height: 8.h),
            ],
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                for (final minutes in presetMinutes)
                  ActionChip(
                    label: Text(DurationFormat.words(Duration(minutes: minutes))),
                    onPressed: () {
                      final duration = Duration(minutes: minutes);
                      context.read<TimersController>().start(
                            recipeTitle: recipeTitle,
                            label: '${DurationFormat.words(duration)} timer',
                            duration: duration,
                          );
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
