import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/models/diet_type.dart';
import 'package:kitchenary/models/difficulty.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';

void main() {
  final meal = <String, dynamic>{
    'idMeal': '52772',
    'strMeal': 'Teriyaki Chicken Casserole',
    'strCategory': 'Chicken',
    'strArea': 'Japanese',
    'strInstructions': 'Preheat oven.\r\n\r\nMix the sauce.\r\nBake for 30 minutes.',
    'strMealThumb': 'https://example.com/a.jpg',
    'strTags': 'Meat, Casserole',
    'strYoutube': 'https://www.youtube.com/watch?v=4aZr5hZXP_s',
    'strIngredient1': 'soy sauce',
    'strMeasure1': '3/4 cup',
    'strIngredient2': 'water',
    'strMeasure2': '1/2 cup',
    'strIngredient3': '',
    'strMeasure3': ' ',
    'strSource': '',
  };

  group('Recipe.fromMealDb', () {
    final recipe = Recipe.fromMealDb(meal);

    test('reads basic fields', () {
      expect(recipe.id, '52772');
      expect(recipe.title, 'Teriyaki Chicken Casserole');
      expect(recipe.tags, ['Meat', 'Casserole']);
      expect(recipe.hasVideo, isTrue);
      expect(recipe.hasSourceUrl, isFalse);
      expect(recipe.isSummary, isFalse);
    });

    test('skips blank ingredients and joins measure with name', () {
      expect(recipe.ingredients, hasLength(2));
      expect(recipe.ingredients.first.displayText, '3/4 cup soy sauce');
    });

    test('splits instructions on line breaks', () {
      expect(recipe.steps, ['Preheat oven.', 'Mix the sauce.', 'Bake for 30 minutes.']);
    });

    test('derives diet from category', () {
      expect(recipe.diet, DietType.nonVeg);
      expect(
        Recipe.fromMealDb({...meal, 'strCategory': 'Vegan'}).diet,
        DietType.vegan,
      );
      expect(
        Recipe.fromMealDb({...meal, 'strCategory': 'Dessert'}).diet,
        DietType.unknown,
      );
    });

    test('round-trips through JSON', () {
      final restored = Recipe.fromJson(recipe.toJson());
      expect(restored.title, recipe.title);
      expect(restored.steps, recipe.steps);
      expect(restored.ingredients.last.name, 'water');
    });
  });

  group('Recipe.splitInstructions', () {
    test('drops STEP headings and numbering', () {
      final steps = Recipe.splitInstructions('STEP 1\nChop onions\nSTEP 2\n2. Fry them');
      expect(steps, ['Chop onions', 'Fry them']);
    });

    test('groups a long paragraph into several steps', () {
      const sentence = 'Stir the pot gently for a while. ';
      final steps = Recipe.splitInstructions(sentence * 20);
      expect(steps.length, greaterThan(1));
      expect(steps.every((s) => s.length <= 260), isTrue);
    });

    test('empty text gives no steps', () {
      expect(Recipe.splitInstructions('  '), isEmpty);
    });
  });

  group('Recipe.difficulty', () {
    Recipe build(int ingredients, int steps) => Recipe(
          id: 'x',
          title: 't',
          imageUrl: '',
          ingredients: List.generate(
            ingredients,
            (i) => const RecipeIngredient(name: 'item'),
          ),
          steps: List.generate(steps, (i) => 'step'),
        );

    test('few ingredients and steps is easy', () {
      expect(build(5, 3).difficulty, Difficulty.easy);
    });
    test('mid-sized is medium', () {
      expect(build(10, 7).difficulty, Difficulty.medium);
    });
    test('large is hard', () {
      expect(build(16, 12).difficulty, Difficulty.hard);
    });
  });
}
