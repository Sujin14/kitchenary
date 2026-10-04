import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/views/widgets/common/skeleton_box.dart';

/// Loading twin of `IngredientRow`: bullet, gap and one text line.
/// [widthFactor] varies the line length so the list looks natural.
class IngredientRowSkeleton extends StatelessWidget {
  const IngredientRowSkeleton({required this.widthFactor, super.key});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: SkeletonBox(width: 7.r, height: 7.r, circle: true),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: widthFactor,
              child: SkeletonBox(height: 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}
