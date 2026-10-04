import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kitchenary/core/navigation/app_routes.dart';
import 'package:kitchenary/models/recipe.dart';

/// Navigation helpers used by widgets.
extension AppNavigation on BuildContext {
  void goHome() => GoRouter.of(this).go(AppRoutes.home);

  /// Opens the details screen for [recipe]. The recipe is passed as `extra`
  /// so the screen can show its title and photo immediately.
  Future<void> openRecipe(Recipe recipe) =>
      GoRouter.of(this).push<void>(AppRoutes.recipe(recipe.id), extra: recipe);

  /// Goes back, or to Home when there is nothing to go back to (deep link).
  void popOrHome() {
    final router = GoRouter.of(this);
    if (router.canPop()) {
      router.pop();
    } else {
      router.go(AppRoutes.home);
    }
  }
}
