import 'package:go_router/go_router.dart';
import 'package:kitchenary/core/constants/legal_content.dart';
import 'package:kitchenary/core/navigation/app_routes.dart';
import 'package:kitchenary/models/cooking_session.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/screens/cooking_screen.dart';
import 'package:kitchenary/views/screens/history_screen.dart';
import 'package:kitchenary/views/screens/home_screen.dart';
import 'package:kitchenary/views/screens/legal_screen.dart';
import 'package:kitchenary/views/screens/main_shell_screen.dart';
import 'package:kitchenary/views/screens/my_recipes_screen.dart';
import 'package:kitchenary/views/screens/onboarding_screen.dart';
import 'package:kitchenary/views/screens/order_screen.dart';
import 'package:kitchenary/views/screens/profile_screen.dart';
import 'package:kitchenary/views/screens/recipe_details_screen.dart';
import 'package:kitchenary/views/screens/recipe_editor_screen.dart';
import 'package:kitchenary/views/screens/saved_screen.dart';
import 'package:kitchenary/views/screens/shopping_screen.dart';
import 'package:kitchenary/views/screens/splash_screen.dart';

/// The app's go_router configuration.
///
/// The five tabs live in a [StatefulShellRoute] so each keeps its own scroll
/// position. Everything else opens on top of the tabs.
abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.saved,
                builder: (context, state) => const SavedScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.mine,
                builder: (context, state) => const MyRecipesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.shopping,
                builder: (context, state) => const ShoppingScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
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
      GoRoute(
        path: AppRoutes.cookingPattern,
        // Cooking mode needs the chosen servings, so a bare link goes to the
        // recipe page instead.
        redirect: (context, state) => state.extra is CookingSession
            ? null
            : AppRoutes.recipe(state.pathParameters['id'] ?? ''),
        builder: (context, state) =>
            CookingScreen(session: state.extra as CookingSession),
      ),
      GoRoute(
        path: AppRoutes.recipeNew,
        builder: (context, state) => const RecipeEditorScreen(),
      ),
      GoRoute(
        path: AppRoutes.recipeEdit,
        builder: (context, state) {
          final extra = state.extra;
          return RecipeEditorScreen(existing: extra is Recipe ? extra : null);
        },
      ),
      GoRoute(
        path: AppRoutes.order,
        builder: (context, state) => const OrderScreen(),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.legalPattern,
        builder: (context, state) => LegalScreen(
          document: LegalContent.bySlug(state.pathParameters['slug'] ?? '') ??
              LegalContent.about,
        ),
      ),
    ],
    errorBuilder: (context, state) => const HomeScreen(),
  );
}
