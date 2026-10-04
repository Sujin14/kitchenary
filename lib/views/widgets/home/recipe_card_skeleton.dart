import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/views/widgets/common/app_card.dart';
import 'package:kitchenary/views/widgets/common/shimmer_scope.dart';
import 'package:kitchenary/views/widgets/common/skeleton_box.dart';

/// Loading twin of `RecipeCard`: same card, same photo area, same padding,
/// and two title lines where the title will be.
class RecipeCardSkeleton extends StatelessWidget {
  const RecipeCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: ShimmerScope(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SkeletonBox(radius: 0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: double.infinity, height: 13.sp),
                  SizedBox(height: 6.h),
                  SkeletonBox(width: 90.w, height: 13.sp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
