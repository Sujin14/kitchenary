import 'dart:convert';

import 'package:kitchenary/models/shopping_item.dart';
import 'package:kitchenary/services/local_store.dart';

/// Saves the shopping list as JSON on the device.
class ShoppingListRepository {
  const ShoppingListRepository(this._store, this._key);

  final LocalStore _store;
  final String _key;

  /// Returns the stored items, or an empty list if nothing valid is stored.
  List<ShoppingItem> load() {
    final raw = _store.read(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(ShoppingItem.fromJson)
          .where((item) => item.id.isNotEmpty && item.name.trim().isNotEmpty)
          .toList();
    } on FormatException {
      return const [];
    }
  }

  Future<void> save(List<ShoppingItem> items) =>
      _store.write(_key, jsonEncode(items.map((i) => i.toJson()).toList()));

  Future<void> clear() => _store.remove(_key);
}
