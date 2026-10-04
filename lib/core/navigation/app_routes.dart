/// Route paths (go_router). Widgets navigate with the helpers in
/// `app_navigation.dart`, so they never import screens.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';

  /// Pattern registered with the router.
  static const String recipeDetails = '/recipe/:id';

  /// Concrete location for a recipe.
  static String recipe(String id) => '/recipe/$id';
}
