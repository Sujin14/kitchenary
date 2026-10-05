import 'dart:math';

import 'package:kitchenary/controllers/offline_status_controller.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_filter.dart';
import 'package:kitchenary/services/api_exception.dart';
import 'package:kitchenary/services/recipe_cache.dart';
import 'package:kitchenary/services/recipe_service.dart';

/// Wraps another [RecipeService] and keeps what it returns on the device.
///
/// Feeds and searches go to the internet first and fall back to the saved
/// copy when that fails. Full recipes are served from the saved copy first,
/// because a recipe does not change.
class CachingRecipeService implements RecipeService {
  CachingRecipeService(
    this._inner,
    this._cache,
    this._status, {
    Random? random,
  }) : _random = random ?? Random();

  final RecipeService _inner;
  final RecipeCache _cache;
  final OfflineStatusController _status;
  final Random _random;

  @override
  Future<List<Recipe>> search(String query) => _list(
        RecipeCache.searchKey(query),
        () => _inner.search(query),
        cacheEach: true,
      );

  @override
  Future<List<Recipe>> browse(List<RecipeFilter> filters) =>
      _list(
        RecipeCache.browseKey(filters),
        () => _inner.browse(filters),
        fallback: _cache.readAnyBrowse,
      );

  @override
  Future<Recipe?> lookup(String id) async {
    final cached = _cache.readRecipe(id);
    if (cached != null && !cached.isSummary) return cached;
    final recipe = await _inner.lookup(id);
    _status.markOnline();
    if (recipe != null && !recipe.isSummary) await _cache.writeRecipe(recipe);
    return recipe;
  }

  @override
  Future<Recipe?> random() async {
    try {
      final recipe = await _inner.random();
      _status.markOnline();
      if (recipe != null && !recipe.isSummary) await _cache.writeRecipe(recipe);
      return recipe;
    } on ApiException {
      final saved = _cache.allFullRecipes();
      if (saved.isEmpty) rethrow;
      _status.markOffline();
      return saved[_random.nextInt(saved.length)];
    }
  }

  Future<List<Recipe>> _list(
    String key,
    Future<List<Recipe>> Function() fetch, {
    bool cacheEach = false,
    List<Recipe>? Function()? fallback,
  }) async {
    try {
      final recipes = await fetch();
      _status.markOnline();
      if (recipes.isNotEmpty) {
        await _cache.writeList(key, recipes);
        if (cacheEach) {
          for (final recipe in recipes.where((r) => !r.isSummary)) {
            await _cache.writeRecipe(recipe);
          }
        }
      }
      return recipes;
    } on ApiException {
      final saved = _cache.readList(key) ?? fallback?.call();
      if (saved == null) rethrow;
      _status.markOffline();
      return saved;
    }
  }

  @override
  void dispose() => _inner.dispose();
}
