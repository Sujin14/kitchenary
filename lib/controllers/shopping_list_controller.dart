import 'package:flutter/foundation.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';
import 'package:kitchenary/models/shopping_item.dart';
import 'package:kitchenary/services/shopping_list_repository.dart';

/// How many ingredients were put on the list and how many were already there.
class AddToListResult {
  const AddToListResult({required this.added, required this.skipped});

  final int added;
  final int skipped;
}

/// The shopping list: items from recipes or typed in by hand. Stored on the
/// device. Unticked items come first, ticked ones sink to the bottom.
class ShoppingListController extends ChangeNotifier {
  ShoppingListController(this._repository) : _items = _repository.load();

  final ShoppingListRepository _repository;
  List<ShoppingItem> _items;
  int _idCounter = 0;

  /// Unticked items first, then ticked ones; order within each is kept.
  List<ShoppingItem> get items => [
        ..._items.where((i) => !i.checked),
        ..._items.where((i) => i.checked),
      ];

  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;
  int get checkedCount => _items.where((i) => i.checked).length;
  int get remainingCount => count - checkedCount;
  bool get hasChecked => checkedCount > 0;

  /// Adds [ingredients] (amounts already scaled). Ingredients whose name is
  /// already on the list are skipped.
  Future<AddToListResult> addIngredients(
    Iterable<RecipeIngredient> ingredients, {
    required String recipeTitle,
  }) async {
    final known = {for (final item in _items) item.key};
    final fresh = <ShoppingItem>[];
    var skipped = 0;
    for (final ingredient in ingredients) {
      final name = ingredient.name.trim();
      if (name.isEmpty) continue;
      final item = ShoppingItem(
        id: _newId(),
        name: name,
        measure: ingredient.measure.trim(),
        recipeTitle: recipeTitle,
      );
      if (known.add(item.key)) {
        fresh.add(item);
      } else {
        skipped++;
      }
    }
    if (fresh.isNotEmpty) {
      _items = [..._items, ...fresh];
      notifyListeners();
      await _repository.save(_items);
    }
    return AddToListResult(added: fresh.length, skipped: skipped);
  }

  /// Adds one item typed in by hand. Returns false when it is empty or
  /// already on the list.
  Future<bool> addCustom(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return false;
    final item = ShoppingItem(id: _newId(), name: trimmed);
    if (_items.any((i) => i.key == item.key)) return false;
    _items = [..._items, item];
    notifyListeners();
    await _repository.save(_items);
    return true;
  }

  Future<void> toggle(String id) async {
    _items = [
      for (final item in _items)
        item.id == id ? item.copyWith(checked: !item.checked) : item,
    ];
    notifyListeners();
    await _repository.save(_items);
  }

  /// Ticks or unticks an item (no change if it is already in that state).
  Future<void> setChecked(String id, {required bool checked}) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index < 0 || _items[index].checked == checked) return;
    _items = [
      for (final item in _items)
        item.id == id ? item.copyWith(checked: checked) : item,
    ];
    notifyListeners();
    await _repository.save(_items);
  }

  Future<void> remove(String id) async {
    _items = _items.where((i) => i.id != id).toList();
    notifyListeners();
    await _repository.save(_items);
  }

  Future<void> clearChecked() async {
    _items = _items.where((i) => !i.checked).toList();
    notifyListeners();
    await _repository.save(_items);
  }

  Future<void> clear() async {
    _items = [];
    notifyListeners();
    await _repository.clear();
  }

  /// Plain text of what is still to buy, for sharing or pasting.
  String asText() {
    final lines = [
      for (final item in _items.where((i) => !i.checked))
        '- ${item.displayText}',
    ];
    return ['Shopping list (${AppConstants.appName})', ...lines].join('\n');
  }

  String _newId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';
}
