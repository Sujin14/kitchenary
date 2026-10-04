import 'package:flutter/material.dart';
import 'package:kitchenary/core/theme/app_colors.dart';

/// Short, readable access to theme data.
extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// The active colour palette (light or dark). Use this for every colour.
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
