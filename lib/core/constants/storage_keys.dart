/// Keys used in the on-device store.
abstract final class StorageKeys {
  static const String savedRecipes = 'saved_recipes';
  static const String history = 'history';
  static const String ownRecipes = 'own_recipes';
  static const String shoppingList = 'shopping_list';
  static const String onboardingDone = 'onboarding_done';
  static const String userName = 'user_name';
  static const String themeMode = 'theme_mode';

  /// Recipes kept for offline use. Every cache key starts with this prefix.
  static const String cachePrefix = 'cache.';
  static const String cacheIndex = 'cache.index';
}
