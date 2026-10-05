/// An Indian grocery delivery service the shopping list can open.
class GroceryStore {
  const GroceryStore({
    required this.id,
    required this.name,
    required this.searchUrl,
    required this.homeUrl,
  });

  final String id;
  final String name;

  /// Search page address with `{query}` where the item name goes.
  final String searchUrl;
  final String homeUrl;

  /// Address that searches this store for [item].
  String searchFor(String item) => searchUrl.replaceFirst(
        '{query}',
        Uri.encodeQueryComponent(item.trim()),
      );
}
