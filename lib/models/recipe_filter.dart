/// How a browse chip is turned into an API request.
enum FilterKind {
  /// TheMealDB category, e.g. `Chicken`, `Vegetarian`.
  category,

  /// TheMealDB cuisine (area), e.g. `Indian`.
  area,

  /// Main ingredient, e.g. `Potatoes`.
  ingredient,

  /// Free-text search of recipe names.
  search,
}

class RecipeFilter {
  const RecipeFilter(this.kind, this.value, {String? label})
      : label = label ?? value;

  final FilterKind kind;
  final String value;

  /// Text shown on the chip.
  final String label;
}
