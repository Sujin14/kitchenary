import 'package:flutter/foundation.dart';
import 'package:kitchenary/models/diet_type.dart';
import 'package:kitchenary/models/draft_line.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';

/// The draft behind the "New recipe" / "Edit recipe" form.
class RecipeEditorController extends ChangeNotifier {
  RecipeEditorController({Recipe? existing})
      : _existing = existing,
        _title = existing?.title ?? '',
        _diet = existing?.customDiet ?? DietType.vegetarian {
    if (existing != null) {
      for (final i in existing.ingredients) {
        _ingredients.add(
          DraftIngredient(_nextId(), name: i.name, measure: i.measure),
        );
      }
      for (final s in existing.steps) {
        _steps.add(DraftLine(_nextId(), s));
      }
    }
    if (_ingredients.isEmpty) _ingredients.add(DraftIngredient(_nextId()));
    if (_steps.isEmpty) _steps.add(DraftLine(_nextId()));
  }

  final Recipe? _existing;
  final List<DraftIngredient> _ingredients = [];
  final List<DraftLine> _steps = [];
  String _title;
  DietType _diet;
  int _lastId = 0;

  int _nextId() => ++_lastId;

  bool get isEditing => _existing != null;
  String get title => _title;
  DietType get diet => _diet;
  List<DraftIngredient> get ingredients => List.unmodifiable(_ingredients);
  List<DraftLine> get steps => List.unmodifiable(_steps);

  void setTitle(String value) => _title = value;

  void setDiet(DietType value) {
    if (value == _diet) return;
    _diet = value;
    notifyListeners();
  }

  void addIngredient() {
    _ingredients.add(DraftIngredient(_nextId()));
    notifyListeners();
  }

  void removeIngredient(int id) {
    if (_ingredients.length <= 1) return;
    _ingredients.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void setIngredientName(int id, String value) {
    for (final i in _ingredients) {
      if (i.id == id) i.name = value;
    }
  }

  void setIngredientMeasure(int id, String value) {
    for (final i in _ingredients) {
      if (i.id == id) i.measure = value;
    }
  }

  void addStep() {
    _steps.add(DraftLine(_nextId()));
    notifyListeners();
  }

  void removeStep(int id) {
    if (_steps.length <= 1) return;
    _steps.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void setStep(int id, String value) {
    for (final s in _steps) {
      if (s.id == id) s.text = value;
    }
  }

  /// What is missing before the recipe can be saved, or null if it is ready.
  String? get problem {
    if (_title.trim().isEmpty) return 'Give your recipe a name.';
    if (!_ingredients.any((i) => i.name.trim().isNotEmpty)) {
      return 'Add at least one ingredient.';
    }
    if (!_steps.any((s) => s.text.trim().isNotEmpty)) {
      return 'Add at least one step.';
    }
    return null;
  }

  /// Builds the recipe. Call only when [problem] is null. Empty rows are
  /// dropped. [newId] is used when this is a new recipe.
  Recipe build(String newId) {
    final base = _existing;
    return Recipe(
      id: base?.id ?? newId,
      title: _title.trim(),
      imageUrl: base?.imageUrl ?? '',
      ingredients: [
        for (final i in _ingredients)
          if (i.name.trim().isNotEmpty)
            RecipeIngredient(name: i.name.trim(), measure: i.measure.trim()),
      ],
      steps: [
        for (final s in _steps)
          if (s.text.trim().isNotEmpty) s.text.trim(),
      ],
      customDiet: _diet,
    );
  }
}
