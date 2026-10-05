import 'dart:convert';

import 'package:kitchenary/core/constants/storage_keys.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_filter.dart';
import 'package:kitchenary/services/local_store.dart';

/// Recipes kept on the device so the app still works without internet.
///
/// Holds a bounded number of entries; when it is full the oldest go first.
/// Each entry is either one full recipe or a list of recipes (a feed or a
/// search result).
class RecipeCache {
  RecipeCache(this._store, {this.maxEntries = 300})
      : _keys = _loadIndex(_store);

  static const String _recipePrefix = '${StorageKeys.cachePrefix}recipe.';

  final LocalStore _store;
  final int maxEntries;

  /// Cached keys, oldest first. Also saved on the device.
  final List<String> _keys;

  static String recipeKey(String id) => '$_recipePrefix$id';

  static String searchKey(String query) =>
      '${StorageKeys.cachePrefix}search.${query.trim().toLowerCase()}';

  static String browseKey(List<RecipeFilter> filters) =>
      '${StorageKeys.cachePrefix}browse.'
      '${filters.map((f) => '${f.kind.name}:${f.value}').join('|')}';

  static List<String> _loadIndex(LocalStore store) {
    final raw = store.read(StorageKeys.cacheIndex);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded.whereType<String>().toList();
    } on FormatException {
      // Corrupt index: start again, the entries will be rewritten.
    }
    return [];
  }

  int get length => _keys.length;

  List<Recipe>? readList(String key) {
    final decoded = _decode(key);
    if (decoded is! List) return null;
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(Recipe.fromJson)
        .where((r) => r.id.isNotEmpty)
        .toList();
  }

  Recipe? readRecipe(String id) {
    final decoded = _decode(recipeKey(id));
    if (decoded is! Map<String, dynamic>) return null;
    final recipe = Recipe.fromJson(decoded);
    return recipe.id.isEmpty ? null : recipe;
  }

  /// The most recently saved feed recipes, merged from every saved feed.
  /// Used when the exact feed asked for was never saved (for example the
  /// random mix, which is different each time). Null when there are none.
  List<Recipe>? readAnyBrowse({int limit = 24}) {
    const prefix = '${StorageKeys.cachePrefix}browse.';
    final merged = <Recipe>[];
    final seen = <String>{};
    for (final key in _keys.reversed) {
      if (!key.startsWith(prefix)) continue;
      for (final recipe in readList(key) ?? const <Recipe>[]) {
        if (seen.add(recipe.id)) merged.add(recipe);
        if (merged.length >= limit) return merged;
      }
    }
    return merged.isEmpty ? null : merged;
  }

  /// Every full (not summary) recipe in the cache, for offline "surprise me".
  List<Recipe> allFullRecipes() {
    final recipes = <Recipe>[];
    for (final key in _keys) {
      if (!key.startsWith(_recipePrefix)) continue;
      final recipe = readRecipe(key.substring(_recipePrefix.length));
      if (recipe != null && !recipe.isSummary) recipes.add(recipe);
    }
    return recipes;
  }

  Future<void> writeList(String key, List<Recipe> recipes) =>
      _put(key, jsonEncode(recipes.map((r) => r.toJson()).toList()));

  Future<void> writeRecipe(Recipe recipe) =>
      _put(recipeKey(recipe.id), jsonEncode(recipe.toJson()));

  Future<void> clear() async {
    for (final key in _keys) {
      await _store.remove(key);
    }
    _keys.clear();
    await _store.remove(StorageKeys.cacheIndex);
  }

  Object? _decode(String key) {
    final raw = _store.read(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw);
    } on FormatException {
      return null;
    }
  }

  Future<void> _put(String key, String json) async {
    await _store.write(key, json);
    _keys
      ..remove(key)
      ..add(key);
    while (_keys.length > maxEntries) {
      await _store.remove(_keys.removeAt(0));
    }
    await _store.write(StorageKeys.cacheIndex, jsonEncode(_keys));
  }
}
