/// Route paths (go_router). Widgets navigate with the helpers in
/// `app_navigation.dart`, so they never import screens.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // Bottom-navigation tabs.
  static const String home = '/home';
  static const String saved = '/saved';
  static const String mine = '/mine';
  static const String profile = '/profile';

  /// Pattern registered with the router.
  static const String recipeDetails = '/recipe/:id';

  /// Concrete location for a recipe.
  static String recipe(String id) => '/recipe/$id';

  // Recipe editor (outside the tabs, so the bottom bar is hidden).
  static const String recipeNew = '/mine/new';
  static const String recipeEdit = '/mine/edit';

  static const String history = '/history';

  /// Pattern registered with the router; the slug picks the document.
  static const String legalPattern = '/legal/:slug';

  static String legal(String slug) => '/legal/$slug';
}
