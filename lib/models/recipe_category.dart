import 'package:kitchenary/models/recipe_filter.dart';

/// A top-level browse chip on the Home screen, with optional sub-chips.
///
/// The ingredient values below are TheMealDB ingredient names; if a chip
/// returns nothing on a device, check the spelling here (one place only).
class RecipeCategory {
  const RecipeCategory({
    required this.name,
    required this.filters,
    this.subcategories = const [],
  });

  final String name;

  /// Requests merged to fill the feed when no sub-chip is selected.
  final List<RecipeFilter> filters;
  final List<RecipeFilter> subcategories;

  static const RecipeCategory indian = RecipeCategory(
    name: 'Indian',
    filters: [RecipeFilter(FilterKind.area, 'Indian')],
  );

  static const RecipeCategory veg = RecipeCategory(
    name: 'Veg',
    filters: [
      RecipeFilter(FilterKind.category, 'Vegetarian'),
      RecipeFilter(FilterKind.category, 'Vegan'),
    ],
    subcategories: [
      RecipeFilter(FilterKind.ingredient, 'Potatoes', label: 'Potato'),
      RecipeFilter(FilterKind.ingredient, 'Tomatoes', label: 'Tomato'),
      RecipeFilter(FilterKind.ingredient, 'Onions', label: 'Onion'),
      RecipeFilter(FilterKind.ingredient, 'Carrots', label: 'Carrot'),
      RecipeFilter(FilterKind.ingredient, 'Spinach'),
      RecipeFilter(FilterKind.ingredient, 'Chickpeas'),
      RecipeFilter(FilterKind.ingredient, 'Lentils'),
    ],
  );

  static const RecipeCategory nonVeg = RecipeCategory(
    name: 'Non-veg',
    filters: [
      RecipeFilter(FilterKind.category, 'Chicken'),
      RecipeFilter(FilterKind.category, 'Seafood'),
      RecipeFilter(FilterKind.category, 'Goat'),
      RecipeFilter(FilterKind.category, 'Lamb'),
    ],
    subcategories: [
      RecipeFilter(FilterKind.category, 'Chicken'),
      RecipeFilter(FilterKind.category, 'Seafood', label: 'Fish & seafood'),
      RecipeFilter(FilterKind.category, 'Goat', label: 'Mutton'),
      RecipeFilter(FilterKind.category, 'Lamb'),
      RecipeFilter(FilterKind.category, 'Beef'),
      RecipeFilter(FilterKind.category, 'Pork'),
    ],
  );

  static const RecipeCategory breakfast = RecipeCategory(
    name: 'Breakfast',
    filters: [RecipeFilter(FilterKind.category, 'Breakfast')],
  );

  static const RecipeCategory dessert = RecipeCategory(
    name: 'Dessert',
    filters: [RecipeFilter(FilterKind.category, 'Dessert')],
  );

  /// Where the "mixed" Home feed (no pill or filter chosen) takes its
  /// recipes from: a few of these are picked at random each time.
  static const List<RecipeFilter> mixPool = [
    RecipeFilter(FilterKind.category, 'Beef'),
    RecipeFilter(FilterKind.category, 'Breakfast'),
    RecipeFilter(FilterKind.category, 'Chicken'),
    RecipeFilter(FilterKind.category, 'Dessert'),
    RecipeFilter(FilterKind.category, 'Lamb'),
    RecipeFilter(FilterKind.category, 'Miscellaneous'),
    RecipeFilter(FilterKind.category, 'Pasta'),
    RecipeFilter(FilterKind.category, 'Pork'),
    RecipeFilter(FilterKind.category, 'Seafood'),
    RecipeFilter(FilterKind.category, 'Side'),
    RecipeFilter(FilterKind.category, 'Starter'),
    RecipeFilter(FilterKind.category, 'Vegan'),
    RecipeFilter(FilterKind.category, 'Vegetarian'),
    RecipeFilter(FilterKind.area, 'Indian'),
  ];

  /// The two quick pills on Home.
  static const List<RecipeCategory> diets = [veg, nonVeg];

  /// Everything else, offered in the filter sheet.
  static const List<RecipeCategory> others = [indian, breakfast, dessert];

  static const List<RecipeCategory> all = [
    indian,
    veg,
    nonVeg,
    breakfast,
    dessert,
  ];
}
