import 'package:flutter/foundation.dart';
import 'package:kitchenary/models/cooking_session.dart';
import 'package:kitchenary/models/recipe.dart';

/// Drives cooking mode.
///
/// Pages: 0 = gather ingredients, 1..n = the method steps, n+1 = all done.
class CookingController extends ChangeNotifier {
  CookingController(this.session)
      : _ingredientTexts = session.ingredientTexts;

  final CookingSession session;
  final List<String> _ingredientTexts;
  final Set<int> _checked = {};
  int _page = 0;

  Recipe get recipe => session.recipe;
  int get servings => session.servings;
  List<String> get steps => recipe.steps;
  int get stepCount => steps.length;

  /// Ingredient lines with amounts scaled to the chosen servings.
  List<String> get ingredientTexts => List.unmodifiable(_ingredientTexts);

  int get pageCount => stepCount + 2;
  int get page => _page;

  bool get isIngredientsPage => _page == 0;
  bool get isDonePage => _page == pageCount - 1;
  bool get isStepPage => !isIngredientsPage && !isDonePage;
  bool get isLastStep => _page == stepCount;

  /// The 1-based number of the current step (only on step pages).
  int get stepNumber => _page;

  /// 0 on the first page, 1 on the last.
  double get progress => pageCount <= 1 ? 1 : _page / (pageCount - 1);

  void setPage(int value) {
    final clamped = value.clamp(0, pageCount - 1);
    if (clamped == _page) return;
    _page = clamped;
    notifyListeners();
  }

  bool isChecked(int index) => _checked.contains(index);
  int get checkedCount => _checked.length;

  void toggleIngredient(int index) {
    if (index < 0 || index >= _ingredientTexts.length) return;
    if (!_checked.add(index)) _checked.remove(index);
    notifyListeners();
  }
}
