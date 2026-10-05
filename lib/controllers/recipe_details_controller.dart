import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:kitchenary/controllers/load_status.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/services/api_exception.dart';
import 'package:kitchenary/services/recipe_service.dart';

/// Loads the full recipe behind a summary card.
///
/// [onLoaded] is called (after the current frame) each time a full recipe is
/// ready, so the app can record it in the history.
class RecipeDetailsController extends ChangeNotifier {
  RecipeDetailsController(
    this._service,
    Recipe initial, {
    this.onLoaded,
  }) : _recipe = initial,
       _servings = initial.servings {
    if (initial.isSummary) {
      load();
    } else {
      _status = LoadStatus.success;
      _announce();
    }
  }

  final RecipeService _service;
  final void Function(Recipe recipe)? onLoaded;
  Recipe _recipe;
  int _servings;
  LoadStatus _status = LoadStatus.loading;
  String _errorMessage = '';
  bool _disposed = false;

  static const int minServings = 1;
  static const int maxServings = 24;

  Recipe get recipe => _recipe;

  /// How many people the user wants to cook for.
  int get servings => _servings;

  /// Multiplier applied to the listed amounts.
  double get scaleFactor {
    final base = _recipe.servings;
    return base <= 0 ? 1 : _servings / base;
  }

  /// The ingredient lines with amounts scaled to [servings].
  List<String> get ingredientTexts => [
        for (final ingredient in _recipe.ingredients)
          ingredient.scaledText(scaleFactor),
      ];

  void setServings(int value) {
    final clamped = value.clamp(minServings, maxServings);
    if (clamped == _servings) return;
    _servings = clamped;
    _notify();
  }
  LoadStatus get status => _status;
  String get errorMessage => _errorMessage;

  Future<void> load() async {
    _status = LoadStatus.loading;
    _notify();
    try {
      final full = await _service.lookup(_recipe.id);
      if (full == null) {
        _errorMessage = 'This recipe is no longer available.';
        _status = LoadStatus.error;
      } else {
        final untouched = _servings == _recipe.servings;
        _recipe = full;
        if (untouched) _servings = full.servings;
        _status = LoadStatus.success;
        _announce();
      }
    } on ApiException catch (error) {
      _errorMessage = error.message;
      _status = LoadStatus.error;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      _status = LoadStatus.error;
    }
    _notify();
  }

  void _announce() {
    final callback = onLoaded;
    if (callback == null) return;
    final recipe = _recipe;
    // Deferred so listeners are never notified while the tree is building.
    scheduleMicrotask(() {
      if (!_disposed) callback(recipe);
    });
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
