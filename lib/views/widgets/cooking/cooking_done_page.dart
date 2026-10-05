import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/cooking_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/theme/app_text_styles.dart';
import 'package:provider/provider.dart';

/// Last page: a short well-done message.
class CookingDonePage extends StatelessWidget {
  const CookingDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cooking = context.watch<CookingController>();
    final p = context.palette;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 96.sp, color: p.cookingAccent),
            SizedBox(height: 24.h),
            Text(
              'Enjoy your meal!',
              textAlign: TextAlign.center,
              style: context.textTheme.headlineMedium?.copyWith(
                color: p.cookingText,
                fontSize: AppTextStyles.cookingHeadingSize,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              '${cooking.recipe.title} is ready.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: p.cookingText.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
