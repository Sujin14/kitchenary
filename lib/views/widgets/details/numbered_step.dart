import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';

/// One numbered method step.
///
/// Keep the layout in sync with `NumberedStepSkeleton`.
class NumberedStep extends StatelessWidget {
  const NumberedStep({required this.number, required this.text, super.key});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: p.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: context.textTheme.labelLarge?.copyWith(color: p.primary),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(child: Text(text, style: context.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
