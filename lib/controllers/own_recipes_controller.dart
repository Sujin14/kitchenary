import 'package:flutter/foundation.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/services/recipe_list_repository.dart';

/// Recipes the user wrote themselves. Newest first, stored on the device.
class OwnRecipesController extends ChangeNotifier {
  OwnRecipesController(this._repository) : _recipes = _repository.load();

  final RecipeListRepository _repository;
  List<Recipe> _recipes;
  int _idCounter = 0;

  List<Recipe> get recipes => List.unmodifiable(_recipes);
  int get count => _recipes.length;
  bool get isEmpty => _recipes.isEmpty;

  /// A fresh id for a new recipe.
  String newId() {
    _idCounter++;
    return '${Recipe.ownPrefix}${DateTime.now().microsecondsSinceEpoch}_$_idCounter';
  }

  /// Adds a new recipe, or replaces the one with the same id.
  Future<void> upsert(Recipe recipe) async {
    final exists = _recipes.any((r) => r.id == recipe.id);
    if (exists) {
      _recipes = [for (final r in _recipes) r.id == recipe.id ? recipe : r];
    } else {
      _recipes = [recipe, ..._recipes];
    }
    notifyListeners();
    await _repository.save(_recipes);
  }

  Future<void> delete(String id) async {
    _recipes = _recipes.where((r) => r.id != id).toList();
    notifyListeners();
    await _repository.save(_recipes);
  }

  Future<void> clear() async {
    _recipes = [];
    notifyListeners();
    await _repository.clear();
  }
}
