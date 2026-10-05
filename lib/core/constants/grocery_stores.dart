import 'package:kitchenary/models/grocery_store.dart';

/// The grocery stores offered on the shopping list.
///
/// These are ordinary web addresses: Android opens the store's app when it is
/// installed (when the store has registered the address) and the website
/// otherwise. The search address formats are NOT confirmed with the stores
/// and can change without notice, so check each one on a phone before every
/// release. They live here so they can be fixed in one place.
abstract final class GroceryStores {
  static const GroceryStore blinkit = GroceryStore(
    id: 'blinkit',
    name: 'Blinkit',
    searchUrl: 'https://blinkit.com/s/?q={query}',
    homeUrl: 'https://blinkit.com',
  );

  static const GroceryStore zepto = GroceryStore(
    id: 'zepto',
    name: 'Zepto',
    searchUrl: 'https://www.zeptonow.com/search?query={query}',
    homeUrl: 'https://www.zeptonow.com',
  );

  static const GroceryStore instamart = GroceryStore(
    id: 'instamart',
    name: 'Swiggy Instamart',
    searchUrl: 'https://www.swiggy.com/instamart/search?query={query}',
    homeUrl: 'https://www.swiggy.com/instamart',
  );

  static const GroceryStore bigBasket = GroceryStore(
    id: 'bigbasket',
    name: 'BigBasket',
    searchUrl: 'https://www.bigbasket.com/ps/?q={query}',
    homeUrl: 'https://www.bigbasket.com',
  );

  static const List<GroceryStore> all = [
    blinkit,
    zepto,
    instamart,
    bigBasket,
  ];
}
