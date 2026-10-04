import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/views/widgets/common/shimmer_scope.dart';
import 'package:kitchenary/views/widgets/common/skeleton_box.dart';
import 'package:kitchenary/views/widgets/details/ingredient_row_skeleton.dart';
import 'package:kitchenary/views/widgets/details/numbered_step_skeleton.dart';

/// Loading twin of the details body below the title: the Ingredients block
/// followed by the Method block, with the same headings, gaps and rows.
class RecipeDetailsSkeleton extends StatelessWidget {
  const RecipeDetailsSkeleton({super.key});

  static const List<double> _ingredientWidths = [0.7, 0.55, 0.8, 0.6, 0.75, 0.5];

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 130.w, height: 24.sp),
          SizedBox(height: 10.h),
          for (final factor in _ingredientWidths)
            IngredientRowSkeleton(widthFactor: factor),
          SizedBox(height: 28.h),
          SkeletonBox(width: 90.w, height: 24.sp),
          SizedBox(height: 12.h),
          for (var i = 0; i < 4; i++) const NumberedStepSkeleton(),
        ],
      ),
    );
  }
}
