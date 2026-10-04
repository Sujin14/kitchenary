import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Typography. Headings use Fraunces, body text uses DM Sans (both bundled,
/// SIL Open Font License). Colours are NOT set here; the theme applies them
/// from the active palette. Sizes use `.sp` so text scales with the screen;
/// call only after `ScreenUtilInit` has run.
abstract final class AppTextStyles {
  static const String headingFamily = 'Fraunces';
  static const String bodyFamily = 'DMSans';

  static TextTheme textTheme() => TextTheme(
        displayLarge: _heading(40, FontWeight.w700, 1.1),
        displayMedium: _heading(34, FontWeight.w700, 1.15),
        headlineLarge: _heading(30, FontWeight.w700, 1.2),
        headlineMedium: _heading(26, FontWeight.w700, 1.2),
        headlineSmall: _heading(22, FontWeight.w600, 1.25),
        titleLarge: _heading(20, FontWeight.w600, 1.3),
        titleMedium: _body(16, FontWeight.w700, 1.35),
        titleSmall: _body(14, FontWeight.w700, 1.35),
        bodyLarge: _body(16, FontWeight.w400, 1.5),
        bodyMedium: _body(14, FontWeight.w400, 1.5),
        bodySmall: _body(12, FontWeight.w400, 1.4),
        labelLarge: _body(15, FontWeight.w700, 1.2),
        labelMedium: _body(13, FontWeight.w500, 1.2),
        labelSmall: _body(11, FontWeight.w500, 1.2),
      );

  static TextStyle _heading(double size, FontWeight weight, double height) =>
      TextStyle(
        fontFamily: headingFamily,
        fontSize: size.sp,
        fontWeight: weight,
        height: height,
      );

  static TextStyle _body(double size, FontWeight weight, double height) =>
      TextStyle(
        fontFamily: bodyFamily,
        fontSize: size.sp,
        fontWeight: weight,
        height: height,
      );

  /// Cooking mode sizes: large enough to read from about 3 feet away.
  static double get cookingStepSize => 32.sp;
  static double get cookingHeadingSize => 36.sp;
  static double get cookingIngredientSize => 26.sp;
}
