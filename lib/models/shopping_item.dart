/// One line on the shopping list.
class ShoppingItem {
  const ShoppingItem({
    required this.id,
    required this.name,
    this.measure = '',
    this.recipeTitle = '',
    this.checked = false,
  });

  final String id;
  final String name;

  /// Amount, e.g. "200g". Empty for items typed in by hand.
  final String measure;

  /// The recipe it came from. Empty for items typed in by hand.
  final String recipeTitle;
  final bool checked;

  /// Lower-case name used to spot the same item added twice.
  String get key => name.trim().toLowerCase();

  /// "200g Chicken" or just "Chicken".
  String get displayText => measure.isEmpty ? name : '$measure $name';

  ShoppingItem copyWith({bool? checked}) => ShoppingItem(
        id: id,
        name: name,
        measure: measure,
        recipeTitle: recipeTitle,
        checked: checked ?? this.checked,
      );

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        measure: json['measure'] as String? ?? '',
        recipeTitle: json['recipeTitle'] as String? ?? '',
        checked: json['checked'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'measure': measure,
        'recipeTitle': recipeTitle,
        'checked': checked,
      };
}
