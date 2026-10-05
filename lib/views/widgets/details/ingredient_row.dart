import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';

/// One ingredient line (already scaled) with a bullet.
///
/// Keep the layout in sync with `IngredientRowSkeleton`.
class IngredientRow extends StatelessWidget {
  const IngredientRow({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Icon(Icons.circle, size: 7.r, color: p.accent),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(text, style: context.textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
