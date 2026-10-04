import 'package:flutter/foundation.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/services/recipe_list_repository.dart';

/// Recipes the user has saved (hearted). Newest first, stored on the device.
class SavedRecipesController extends ChangeNotifier {
  SavedRecipesController(this._repository) : _recipes = _repository.load();

  final RecipeListRepository _repository;
  List<Recipe> _recipes;

  List<Recipe> get recipes => List.unmodifiable(_recipes);
  int get count => _recipes.length;
  bool get isEmpty => _recipes.isEmpty;

  bool isSaved(String id) => _recipes.any((r) => r.id == id);

  /// Saves [recipe], or removes it if it is already saved.
  /// Returns true when the recipe is now saved.
  Future<bool> toggle(Recipe recipe) async {
    final nowSaved = !isSaved(recipe.id);
    if (nowSaved) {
      _recipes = [recipe, ..._recipes];
    } else {
      _recipes = _recipes.where((r) => r.id != recipe.id).toList();
    }
    notifyListeners();
    await _repository.save(_recipes);
    return nowSaved;
  }

  /// Replaces a saved summary with the full recipe once it has been loaded,
  /// so it can be opened again later with everything in it.
  Future<void> refresh(Recipe full) async {
    if (full.isSummary || !isSaved(full.id)) return;
    _recipes = [for (final r in _recipes) r.id == full.id ? full : r];
    notifyListeners();
    await _repository.save(_recipes);
  }

  Future<void> clear() async {
    _recipes = [];
    notifyListeners();
    await _repository.clear();
  }
}
