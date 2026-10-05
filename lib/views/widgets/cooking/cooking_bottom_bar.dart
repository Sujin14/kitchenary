import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/cooking_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';

/// Large Back and Next buttons, easy to hit with messy hands.
class CookingBottomBar extends StatelessWidget {
  const CookingBottomBar({
    required this.onBack,
    required this.onNext,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onNext;

  String _nextLabel(CookingController cooking) {
    if (cooking.isIngredientsPage) return 'Start cooking';
    if (cooking.isDonePage) return 'Close';
    if (cooking.isLastStep) return 'Finish';
    return 'Next step';
  }

  @override
  Widget build(BuildContext context) {
    final cooking = context.watch<CookingController>();
    final p = context.palette;
    final height = 64.h;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      child: Row(
        children: [
          SizedBox(
            width: 72.w,
            height: height,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(72.w, height),
                padding: EdgeInsets.zero,
                foregroundColor: p.cookingText,
                side: BorderSide(color: p.cookingTrack, width: 2),
              ),
              onPressed: cooking.isIngredientsPage ? null : onBack,
              child: Icon(Icons.arrow_back, size: 28.sp),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: Size.fromHeight(height),
                backgroundColor: p.cookingAccent,
                foregroundColor: p.cookingBackground,
                textStyle: context.textTheme.titleLarge,
              ),
              onPressed: onNext,
              child: Text(_nextLabel(cooking)),
            ),
          ),
        ],
      ),
    );
  }
}
