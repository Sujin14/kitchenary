import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/timers_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/views/widgets/cooking/cooking_timer_chip.dart';
import 'package:provider/provider.dart';

/// Row of active timers under the cooking-mode top bar. Hidden when empty.
class CookingTimersStrip extends StatelessWidget {
  const CookingTimersStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final timers = context.watch<TimersController>();
    if (!timers.hasTimers) return const SizedBox.shrink();
    final p = context.palette;

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 56.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: timers.timers.length,
              separatorBuilder: (_, _) => SizedBox(width: 10.w),
              itemBuilder: (_, index) {
                final timer = timers.timers[index];
                return CookingTimerChip(
                  timer: timer,
                  remaining: timers.remaining(timer),
                );
              },
            ),
          ),
          if (timers.alertsBlocked)
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
              child: Text(
                'Notifications are off, so you will not be alerted while the '
                'app is closed. Turn them on in phone settings.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: p.cookingAccent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
