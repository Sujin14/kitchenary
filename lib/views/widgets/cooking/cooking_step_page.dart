import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/theme/app_text_styles.dart';
import 'package:kitchenary/views/widgets/cooking/step_timer_buttons.dart';

/// One method step in large type, readable from a distance.
class CookingStepPage extends StatelessWidget {
  const CookingStepPage({
    required this.number,
    required this.text,
    super.key,
  });

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'STEP $number',
              style: context.textTheme.titleMedium?.copyWith(
                color: p.cookingAccent,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              text,
              style: TextStyle(
                fontFamily: AppTextStyles.bodyFamily,
                fontSize: AppTextStyles.cookingStepSize,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: p.cookingText,
              ),
            ),
            StepTimerButtons(stepNumber: number, stepText: text),
          ],
        ),
      ),
    );
  }
}
