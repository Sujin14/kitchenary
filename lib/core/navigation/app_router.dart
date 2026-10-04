import 'package:flutter/material.dart';
import 'package:kitchenary/core/navigation/app_routes.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/screens/home_screen.dart';
import 'package:kitchenary/views/screens/recipe_details_screen.dart';
import 'package:kitchenary/views/screens/splash_screen.dart';

/// Maps route names to screens.
abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(settings, const SplashScreen());
      case AppRoutes.home:
        return _page(settings, const HomeScreen());
      case AppRoutes.recipeDetails:
        final recipe = settings.arguments;
        if (recipe is Recipe) {
          return _page(settings, RecipeDetailsScreen(recipe: recipe));
        }
        return _page(settings, const HomeScreen());
      default:
        return _page(settings, const HomeScreen());
    }
  }

  static MaterialPageRoute<dynamic> _page(RouteSettings s, Widget child) =>
      MaterialPageRoute<dynamic>(settings: s, builder: (_) => child);
}
