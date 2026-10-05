import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/timers_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/utils/duration_format.dart';
import 'package:kitchenary/models/cooking_timer.dart';
import 'package:provider/provider.dart';

/// One running, paused or finished timer in the cooking-mode strip.
class CookingTimerChip extends StatelessWidget {
  const CookingTimerChip({
    required this.timer,
    required this.remaining,
    super.key,
  });

  final CookingTimer timer;
  final Duration remaining;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final controller = context.read<TimersController>();
    final done = timer.isFinished;
    final foreground = done ? p.cookingBackground : p.cookingText;

    return Container(
      padding: EdgeInsets.only(left: 14.w, right: 4.w),
      decoration: BoxDecoration(
        color: done ? p.cookingAccent : p.cookingTrack,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timer.label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: foreground,
                ),
              ),
              Text(
                done ? "Time's up" : DurationFormat.clock(remaining),
                style: context.textTheme.titleMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (!done)
            IconButton(
              tooltip: timer.isRunning ? 'Pause timer' : 'Resume timer',
              color: foreground,
              icon: Icon(
                timer.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
              onPressed: () => timer.isRunning
                  ? controller.pause(timer.id)
                  : controller.resume(timer.id),
            ),
          IconButton(
            tooltip: done ? 'Dismiss' : 'Cancel timer',
            color: foreground,
            icon: const Icon(Icons.close_rounded),
            onPressed: () => controller.remove(timer.id),
          ),
        ],
      ),
    );
  }
}
