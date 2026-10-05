import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/recipe_details_controller.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';

import 'helpers/fake_recipe_service.dart';

Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  const recipe = Recipe(
    id: '1',
    title: 'Dal',
    imageUrl: '',
    ingredients: [RecipeIngredient(name: 'Lentils', measure: '200g')],
    steps: ['Boil.'],
  );

  test('starts at the recipe\'s own servings with unscaled amounts', () {
    final details = RecipeDetailsController(FakeRecipeService(), recipe);
    expect(details.servings, 4);
    expect(details.scaleFactor, 1);
    expect(details.ingredientTexts, ['200g Lentils']);
    details.dispose();
  });

  test('changing servings rescales the ingredient amounts', () {
    final details = RecipeDetailsController(FakeRecipeService(), recipe);
    var calls = 0;
    details.addListener(() => calls++);

    details.setServings(8);
    expect(details.scaleFactor, 2);
    expect(details.ingredientTexts, ['400g Lentils']);

    details.setServings(2);
    expect(details.ingredientTexts, ['100g Lentils']);
    expect(calls, 2);

    details.setServings(2); // unchanged: no notification
    expect(calls, 2);
    details.dispose();
  });

  test('servings stay between 1 and 24', () {
    final details = RecipeDetailsController(FakeRecipeService(), recipe);
    details.setServings(0);
    expect(details.servings, RecipeDetailsController.minServings);
    details.setServings(100);
    expect(details.servings, RecipeDetailsController.maxServings);
    details.dispose();
  });

  test('a recipe written for 6 people scales from 6', () {
    const own = Recipe(
      id: 'own_1',
      title: 'Biryani',
      imageUrl: '',
      servings: 6,
      ingredients: [RecipeIngredient(name: 'Rice', measure: '600g')],
    );
    final details = RecipeDetailsController(FakeRecipeService(), own);
    expect(details.servings, 6);
    details.setServings(3);
    expect(details.ingredientTexts, ['300g Rice']);
    details.dispose();
  });

  test('loading the full recipe keeps ingredients scaled to the choice',
      () async {
    final service = FakeRecipeService()
      ..lookupResult = recipe;
    final details = RecipeDetailsController(
      service,
      const Recipe(id: '1', title: 'Dal', imageUrl: '', isSummary: true),
    );
    details.setServings(8);
    await settle();
    await settle();
    expect(details.servings, 8);
    expect(details.ingredientTexts, ['400g Lentils']);
    details.dispose();
  });
}
