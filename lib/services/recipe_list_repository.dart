import 'dart:convert';

import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/services/local_store.dart';

/// Saves a list of recipes (saved, history, own recipes) as JSON under [key].
class RecipeListRepository {
  const RecipeListRepository(this._store, this._key);

  final LocalStore _store;
  final String _key;

  /// Returns the stored recipes, or an empty list if nothing valid is stored.
  List<Recipe> load() {
    final raw = _store.read(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Recipe.fromJson)
          .where((r) => r.id.isNotEmpty)
          .toList();
    } on FormatException {
      return const [];
    }
  }

  Future<void> save(List<Recipe> recipes) =>
      _store.write(_key, jsonEncode(recipes.map((r) => r.toJson()).toList()));

  Future<void> clear() => _store.remove(_key);
}
