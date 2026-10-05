import 'package:kitchenary/models/recipe.dart';

/// A recipe about to be cooked, for a chosen number of people.
class CookingSession {
  const CookingSession({required this.recipe, required this.servings});

  final Recipe recipe;
  final int servings;

  /// Multiplier applied to the listed amounts.
  double get scaleFactor =>
      recipe.servings <= 0 ? 1 : servings / recipe.servings;

  /// Ingredient lines with amounts scaled to [servings].
  List<String> get ingredientTexts => [
        for (final ingredient in recipe.ingredients)
          ingredient.scaledText(scaleFactor),
      ];
}
