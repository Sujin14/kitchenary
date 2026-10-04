import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/own_recipes_controller.dart';
import 'package:kitchenary/core/constants/storage_keys.dart';
import 'package:kitchenary/models/diet_type.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';
import 'package:kitchenary/services/memory_local_store.dart';
import 'package:kitchenary/services/recipe_list_repository.dart';

void main() {
  late MemoryLocalStore store;

  OwnRecipesController build() => OwnRecipesController(
        RecipeListRepository(store, StorageKeys.ownRecipes),
      );

  setUp(() => store = MemoryLocalStore());

  test('new ids are unique and marked as own', () {
    final own = build();
    final a = own.newId();
    final b = own.newId();
    expect(a, isNot(b));
    expect(a.startsWith(Recipe.ownPrefix), isTrue);
  });

  test('upsert adds new recipes first and replaces existing ones', () async {
    final own = build();
    final idA = own.newId();
    final idB = own.newId();
    await own.upsert(Recipe(id: idA, title: 'A', imageUrl: ''));
    await own.upsert(Recipe(id: idB, title: 'B', imageUrl: ''));
    expect(own.recipes.map((r) => r.title), ['B', 'A']);

    await own.upsert(Recipe(id: idA, title: 'A2', imageUrl: ''));
    expect(own.recipes.map((r) => r.title), ['B', 'A2']);
  });

  test('recipes survive a restart including custom diet', () async {
    final own = build();
    final id = own.newId();
    await own.upsert(
      Recipe(
        id: id,
        title: 'Chicken curry',
        imageUrl: '',
        ingredients: const [
          RecipeIngredient(name: 'Chicken', measure: '500 g'),
        ],
        steps: const ['Cook it'],
        customDiet: DietType.nonVeg,
      ),
    );
    final again = build().recipes.single;
    expect(again.isOwn, isTrue);
    expect(again.diet, DietType.nonVeg);
    expect(again.ingredients.single.displayText, '500 g Chicken');
    expect(again.steps, ['Cook it']);
  });

  test('delete removes one recipe; clear removes all', () async {
    final own = build();
    final a = own.newId();
    final b = own.newId();
    await own.upsert(Recipe(id: a, title: 'A', imageUrl: ''));
    await own.upsert(Recipe(id: b, title: 'B', imageUrl: ''));

    await own.delete(a);
    expect(own.recipes.map((r) => r.id), [b]);
    expect(build().count, 1);

    await own.clear();
    expect(build().isEmpty, isTrue);
  });
}
