import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/cooking_controller.dart';
import 'package:kitchenary/models/cooking_session.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';

void main() {
  const recipe = Recipe(
    id: '1',
    title: 'Dal',
    imageUrl: '',
    servings: 4,
    ingredients: [
      RecipeIngredient(name: 'Lentils', measure: '200g'),
      RecipeIngredient(name: 'Salt', measure: 'to taste'),
    ],
    steps: ['Wash.', 'Boil.', 'Temper.'],
  );

  CookingController build({int servings = 4}) => CookingController(
        CookingSession(recipe: recipe, servings: servings),
      );

  test('pages: ingredients, one per step, then done', () {
    final cooking = build();
    expect(cooking.pageCount, 5);
    expect(cooking.isIngredientsPage, isTrue);
    expect(cooking.isStepPage, isFalse);

    cooking.setPage(1);
    expect(cooking.isStepPage, isTrue);
    expect(cooking.stepNumber, 1);

    cooking.setPage(3);
    expect(cooking.isLastStep, isTrue);

    cooking.setPage(4);
    expect(cooking.isDonePage, isTrue);
  });

  test('progress goes from 0 to 1', () {
    final cooking = build();
    expect(cooking.progress, 0);
    cooking.setPage(2);
    expect(cooking.progress, 0.5);
    cooking.setPage(4);
    expect(cooking.progress, 1);
  });

  test('setPage clamps and only notifies on change', () {
    final cooking = build();
    var calls = 0;
    cooking.addListener(() => calls++);

    cooking.setPage(-3);
    expect(cooking.page, 0);
    expect(calls, 0);

    cooking.setPage(99);
    expect(cooking.page, 4);
    expect(calls, 1);
  });

  test('ingredients are scaled to the chosen servings', () {
    expect(build().ingredientTexts, ['200g Lentils', 'to taste Salt']);
    expect(build(servings: 8).ingredientTexts, [
      '400g Lentils',
      'to taste Salt',
    ]);
    expect(build(servings: 2).ingredientTexts.first, '100g Lentils');
  });

  test('ingredients can be ticked and un-ticked', () {
    final cooking = build();
    cooking.toggleIngredient(0);
    expect(cooking.isChecked(0), isTrue);
    expect(cooking.checkedCount, 1);

    cooking.toggleIngredient(0);
    expect(cooking.isChecked(0), isFalse);

    cooking.toggleIngredient(42); // out of range: ignored
    expect(cooking.checkedCount, 0);
  });
}
