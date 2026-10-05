import 'package:flutter/foundation.dart';
import 'package:kitchenary/models/grocery_store.dart';
import 'package:kitchenary/models/shopping_item.dart';

/// Walks through the shopping list one item at a time for one grocery store,
/// so everything ends up in a single cart and a single order.
///
/// The list of items is fixed when the flow starts. Ticking items off on the
/// shopping list itself is done by the screen, not here.
class OrderController extends ChangeNotifier {
  OrderController(Iterable<ShoppingItem> items)
      : _items = List.unmodifiable(items);

  final List<ShoppingItem> _items;
  GroceryStore? _store;
  int _index = 0;

  List<ShoppingItem> get items => _items;
  int get total => _items.length;
  bool get hasItems => _items.isNotEmpty;

  GroceryStore? get store => _store;
  bool get hasStore => _store != null;

  /// 0-based position of the current item.
  int get index => _index;

  /// 1-based position, for "Item 2 of 7".
  int get position => _index + 1;

  bool get isFirst => _index == 0;

  /// True once every item has been gone through.
  bool get isDone => hasStore && _index >= total;

  /// The item being shopped for, or null before a store is chosen or after
  /// the last item.
  ShoppingItem? get current =>
      hasStore && _index < total ? _items[_index] : null;

  /// How far along, from 0 to 1.
  double get progress => total == 0 ? 0 : _index / total;

  void chooseStore(GroceryStore store) {
    _store = store;
    _index = 0;
    notifyListeners();
  }

  void changeStore() {
    _store = null;
    _index = 0;
    notifyListeners();
  }

  void next() {
    if (!hasStore || _index >= total) return;
    _index++;
    notifyListeners();
  }

  void previous() {
    if (!hasStore || _index == 0) return;
    _index--;
    notifyListeners();
  }
}
