import 'package:flutter/material.dart';
import 'package:kitchenary/core/theme/app_colors.dart';

/// Short, readable access to theme data and navigation.
extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// The active colour palette (light or dark). Use this for every colour.
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;

  Future<T?> pushNamed<T extends Object?>(String route, {Object? arguments}) =>
      Navigator.of(this).pushNamed<T>(route, arguments: arguments);

  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop<T>(result);
}
