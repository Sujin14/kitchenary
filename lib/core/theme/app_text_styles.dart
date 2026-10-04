import 'package:flutter/material.dart';

/// Typography. Headings use Fraunces, body text uses DM Sans (both bundled,
/// SIL Open Font License). Colours are NOT set here; the theme applies them
/// from the active palette.
abstract final class AppTextStyles {
  static const String headingFamily = 'Fraunces';
  static const String bodyFamily = 'DMSans';

  static TextTheme textTheme() => const TextTheme(
        displayLarge: TextStyle(fontFamily: headingFamily, fontSize: 40, fontWeight: FontWeight.w700, height: 1.1),
        displayMedium: TextStyle(fontFamily: headingFamily, fontSize: 34, fontWeight: FontWeight.w700, height: 1.15),
        headlineLarge: TextStyle(fontFamily: headingFamily, fontSize: 30, fontWeight: FontWeight.w700, height: 1.2),
        headlineMedium: TextStyle(fontFamily: headingFamily, fontSize: 26, fontWeight: FontWeight.w700, height: 1.2),
        headlineSmall: TextStyle(fontFamily: headingFamily, fontSize: 22, fontWeight: FontWeight.w600, height: 1.25),
        titleLarge: TextStyle(fontFamily: headingFamily, fontSize: 20, fontWeight: FontWeight.w600, height: 1.3),
        titleMedium: TextStyle(fontFamily: bodyFamily, fontSize: 16, fontWeight: FontWeight.w700, height: 1.35),
        titleSmall: TextStyle(fontFamily: bodyFamily, fontSize: 14, fontWeight: FontWeight.w700, height: 1.35),
        bodyLarge: TextStyle(fontFamily: bodyFamily, fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
        bodyMedium: TextStyle(fontFamily: bodyFamily, fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
        bodySmall: TextStyle(fontFamily: bodyFamily, fontSize: 12, fontWeight: FontWeight.w400, height: 1.4),
        labelLarge: TextStyle(fontFamily: bodyFamily, fontSize: 15, fontWeight: FontWeight.w700, height: 1.2),
        labelMedium: TextStyle(fontFamily: bodyFamily, fontSize: 13, fontWeight: FontWeight.w500, height: 1.2),
        labelSmall: TextStyle(fontFamily: bodyFamily, fontSize: 11, fontWeight: FontWeight.w500, height: 1.2),
      );

  /// Cooking mode sizes: large enough to read from about 3 feet away.
  static const double cookingStepSize = 32;
  static const double cookingHeadingSize = 36;
  static const double cookingIngredientSize = 26;
}
