import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/recipe_editor_controller.dart';
import 'package:kitchenary/models/diet_type.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';

void main() {
  test('a new draft starts with one empty ingredient and one empty step', () {
    final editor = RecipeEditorController();
    expect(editor.isEditing, isFalse);
    expect(editor.ingredients, hasLength(1));
    expect(editor.steps, hasLength(1));
    expect(editor.diet, DietType.vegetarian);
  });

  test('reports what is missing, in order', () {
    final editor = RecipeEditorController();
    expect(editor.problem, 'Give your recipe a name.');

    editor.setTitle('Upma');
    expect(editor.problem, 'Add at least one ingredient.');

    editor.setIngredientName(editor.ingredients.single.id, 'Rava');
    expect(editor.problem, 'Add at least one step.');

    editor.setStep(editor.steps.single.id, 'Roast the rava.');
    expect(editor.problem, isNull);
  });

  test('build drops empty rows and trims text', () {
    final editor = RecipeEditorController()
      ..setTitle('  Upma ')
      ..setDiet(DietType.vegan)
      ..addIngredient()
      ..addStep();
    editor
      ..setIngredientMeasure(editor.ingredients.first.id, ' 1 cup ')
      ..setIngredientName(editor.ingredients.first.id, ' Rava ')
      ..setStep(editor.steps.first.id, ' Roast. ');

    final recipe = editor.build('own_1');

    expect(recipe.id, 'own_1');
    expect(recipe.title, 'Upma');
    expect(recipe.diet, DietType.vegan);
    expect(recipe.ingredients, hasLength(1));
    expect(recipe.ingredients.single.displayText, '1 cup Rava');
    expect(recipe.steps, ['Roast.']);
    expect(recipe.isSummary, isFalse);
  });

  test('the last ingredient and the last step cannot be removed', () {
    final editor = RecipeEditorController();
    editor
      ..removeIngredient(editor.ingredients.single.id)
      ..removeStep(editor.steps.single.id);
    expect(editor.ingredients, hasLength(1));
    expect(editor.steps, hasLength(1));

    editor.addIngredient();
    editor.removeIngredient(editor.ingredients.first.id);
    expect(editor.ingredients, hasLength(1));
  });

  test('editing keeps the id and prefills the form', () {
    const existing = Recipe(
      id: 'own_7',
      title: 'Poha',
      imageUrl: '',
      ingredients: [
        RecipeIngredient(name: 'Poha', measure: '2 cups'),
        RecipeIngredient(name: 'Onion', measure: '1'),
      ],
      steps: ['Wash poha.', 'Fry onion.'],
      customDiet: DietType.vegan,
    );
    final editor = RecipeEditorController(existing: existing);

    expect(editor.isEditing, isTrue);
    expect(editor.title, 'Poha');
    expect(editor.diet, DietType.vegan);
    expect(editor.ingredients, hasLength(2));
    expect(editor.steps.map((s) => s.text), ['Wash poha.', 'Fry onion.']);

    editor.setTitle('Kanda poha');
    final updated = editor.build('ignored');
    expect(updated.id, 'own_7');
    expect(updated.title, 'Kanda poha');
  });
}
