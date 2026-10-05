import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/core/constants/grocery_stores.dart';
import 'package:kitchenary/models/grocery_store.dart';

void main() {
  test('searchFor puts the encoded item into the address', () {
    const store = GroceryStore(
      id: 'x',
      name: 'X',
      searchUrl: 'https://example.com/search?q={query}',
      homeUrl: 'https://example.com',
    );
    expect(
      store.searchFor(' Green chilli '),
      'https://example.com/search?q=Green+chilli',
    );
  });

  test('every configured store has valid https addresses', () {
    expect(GroceryStores.all, isNotEmpty);
    for (final store in GroceryStores.all) {
      expect(store.searchUrl, contains('{query}'), reason: store.name);
      final uri = Uri.parse(store.searchFor('onion'));
      expect(uri.scheme, 'https', reason: store.name);
      expect(uri.host, isNotEmpty, reason: store.name);
      expect(Uri.parse(store.homeUrl).scheme, 'https', reason: store.name);
    }
  });
}
