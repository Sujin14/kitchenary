import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';

/// A rounded progress bar in the cooking colours that glides to its value.
class CookingProgressBar extends StatelessWidget {
  const CookingProgressBar({required this.progress, super.key});

  /// 0 to 1.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: progress),
      duration: const Duration(milliseconds: 250),
      builder: (context, value, _) => ClipRRect(
        borderRadius: BorderRadius.circular(999.r),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 8.h,
          backgroundColor: p.cookingTrack,
          color: p.cookingAccent,
        ),
      ),
    );
  }
}
