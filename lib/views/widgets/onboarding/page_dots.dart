import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';

/// Row of dots showing the current page; the active one is stretched.
class PageDots extends StatelessWidget {
  const PageDots({required this.count, required this.index, super.key});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: i == index ? 24.w : 8.r,
            height: 8.r,
            decoration: BoxDecoration(
              color: i == index ? p.primary : p.outline,
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
      ],
    );
  }
}
