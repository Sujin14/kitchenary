import 'package:flutter/foundation.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/services/recipe_list_repository.dart';

/// Recently viewed recipes, newest first, capped at
/// [AppConstants.historyLimit].
class HistoryController extends ChangeNotifier {
  HistoryController(this._repository) : _recipes = _repository.load();

  final RecipeListRepository _repository;
  List<Recipe> _recipes;

  List<Recipe> get recipes => List.unmodifiable(_recipes);
  int get count => _recipes.length;
  bool get isEmpty => _recipes.isEmpty;

  /// Moves [recipe] to the top of the list. Summaries and the user's own
  /// recipes are not recorded.
  Future<void> record(Recipe recipe) async {
    if (recipe.isSummary || recipe.isOwn) return;
    final rest = _recipes.where((r) => r.id != recipe.id);
    _recipes = [recipe, ...rest].take(AppConstants.historyLimit).toList();
    notifyListeners();
    await _repository.save(_recipes);
  }

  Future<void> clear() async {
    _recipes = [];
    notifyListeners();
    await _repository.clear();
  }
}
