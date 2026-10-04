import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/views/widgets/common/skeleton_box.dart';

/// Loading twin of `NumberedStep`: number circle and two text lines.
class NumberedStepSkeleton extends StatelessWidget {
  const NumberedStepSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 30.r, height: 30.r, circle: true),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: double.infinity, height: 16.sp),
                SizedBox(height: 8.h),
                SkeletonBox(width: 180.w, height: 16.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
