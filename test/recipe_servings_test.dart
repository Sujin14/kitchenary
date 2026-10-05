import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/recipe_editor_controller.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';

void main() {
  group('Recipe.servings', () {
    test('defaults to four, and survives toJson / fromJson', () {
      const plain = Recipe(id: '1', title: 'x', imageUrl: '');
      expect(plain.servings, 4);

      const six = Recipe(id: '2', title: 'x', imageUrl: '', servings: 6);
      expect(Recipe.fromJson(six.toJson()).servings, 6);
    });

    test('older saved data without servings reads as four', () {
      final recipe = Recipe.fromJson({'id': '1', 'title': 'x'});
      expect(recipe.servings, 4);
    });
  });

  group('RecipeIngredient scaling', () {
    const ingredient = RecipeIngredient(name: 'Lentils', measure: '1 1/2 cup');

    test('scaledMeasure and scaledText apply the factor', () {
      expect(ingredient.scaledMeasure(2), '3 cup');
      expect(ingredient.scaledText(2), '3 cup Lentils');
    });

    test('an ingredient without a measure is just its name', () {
      const salt = RecipeIngredient(name: 'Salt');
      expect(salt.scaledText(3), 'Salt');
    });
  });

  group('RecipeEditorController servings', () {
    test('default, change, clamp and build', () {
      final editor = RecipeEditorController();
      expect(editor.servings, 4);

      editor.setServings(6);
      expect(editor.servings, 6);

      editor.setServings(0);
      expect(editor.servings, RecipeEditorController.minServings);
      editor.setServings(500);
      expect(editor.servings, RecipeEditorController.maxServings);

      editor
        ..setServings(6)
        ..setTitle('Pulao')
        ..setIngredientName(editor.ingredients.single.id, 'Rice')
        ..setStep(editor.steps.single.id, 'Cook.');
      expect(editor.build('own_1').servings, 6);
    });

    test('editing starts from the recipe\'s servings', () {
      final editor = RecipeEditorController(
        existing: const Recipe(
          id: 'own_1',
          title: 'Pulao',
          imageUrl: '',
          servings: 8,
        ),
      );
      expect(editor.servings, 8);
    });
  });
}
