import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Grid geometry shared by the real feed and its skeleton, so the loading
/// state occupies exactly the same space as the loaded one.
abstract final class RecipeGridLayout {
  static SliverGridDelegate get delegate =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 14.w,
        childAspectRatio: 0.78,
      );

  static EdgeInsets get padding => EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h);
}
