import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kitchenary/core/navigation/app_routes.dart';
import 'package:kitchenary/models/cooking_session.dart';
import 'package:kitchenary/models/recipe.dart';

/// Navigation helpers used by widgets.
extension AppNavigation on BuildContext {
  void goHome() => GoRouter.of(this).go(AppRoutes.home);

  void goOnboarding() => GoRouter.of(this).go(AppRoutes.onboarding);

  void goMyRecipes() => GoRouter.of(this).go(AppRoutes.mine);

  /// Opens the details screen for [recipe]. The recipe is passed as `extra`
  /// so the screen can show its title and photo immediately.
  Future<void> openRecipe(Recipe recipe) =>
      GoRouter.of(this).push<void>(AppRoutes.recipe(recipe.id), extra: recipe);

  /// Opens step-by-step cooking mode for [session].
  Future<void> openCooking(CookingSession session) => GoRouter.of(this)
      .push<void>(AppRoutes.cooking(session.recipe.id), extra: session);

  /// Opens the recipe form: empty for a new recipe, filled for [existing].
  Future<void> openRecipeEditor([Recipe? existing]) => existing == null
      ? GoRouter.of(this).push<void>(AppRoutes.recipeNew)
      : GoRouter.of(this).push<void>(AppRoutes.recipeEdit, extra: existing);

  Future<void> openHistory() => GoRouter.of(this).push<void>(AppRoutes.history);

  Future<void> openLegal(String slug) =>
      GoRouter.of(this).push<void>(AppRoutes.legal(slug));

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
