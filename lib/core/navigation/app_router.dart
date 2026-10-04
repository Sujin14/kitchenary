import 'package:go_router/go_router.dart';
import 'package:kitchenary/core/navigation/app_routes.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/screens/home_screen.dart';
import 'package:kitchenary/views/screens/recipe_details_screen.dart';
import 'package:kitchenary/views/screens/splash_screen.dart';

/// The app's go_router configuration.
abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.recipeDetails,
        builder: (context, state) {
          final extra = state.extra;
          // Opened from a card: we already know the title and photo. Opened
          // from a link: only the id is known and the screen loads the rest.
          final recipe = extra is Recipe
              ? extra
              : Recipe(
                  id: state.pathParameters['id'] ?? '',
                  title: '',
                  imageUrl: '',
                  isSummary: true,
                );
          return RecipeDetailsScreen(recipe: recipe);
        },
      ),
    ],
    errorBuilder: (context, state) => const HomeScreen(),
  );
}
