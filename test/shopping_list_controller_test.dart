import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/shopping_list_controller.dart';
import 'package:kitchenary/core/constants/storage_keys.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';
import 'package:kitchenary/services/memory_local_store.dart';
import 'package:kitchenary/services/shopping_list_repository.dart';

void main() {
  late MemoryLocalStore store;

  ShoppingListController build() => ShoppingListController(
        ShoppingListRepository(store, StorageKeys.shoppingList),
      );

  const onion = RecipeIngredient(name: 'Onion', measure: '2');
  const rice = RecipeIngredient(name: 'Rice', measure: '200g');

  setUp(() => store = MemoryLocalStore());

  test('starts empty', () {
    final list = build();
    expect(list.isEmpty, isTrue);
    expect(list.remainingCount, 0);
  });

  test('adds recipe ingredients and remembers where they came from', () async {
    final list = build();
    final result = await list.addIngredients([onion, rice], recipeTitle: 'Pulao');

    expect(result.added, 2);
    expect(result.skipped, 0);
    expect(list.items.map((i) => i.name), ['Onion', 'Rice']);
    expect(list.items.first.recipeTitle, 'Pulao');
    expect(list.items.first.measure, '2');
  });

  test('skips names that are already on the list, ignoring case', () async {
    final list = build();
    await list.addIngredients([onion], recipeTitle: 'A');
    final result = await list.addIngredients(
      [const RecipeIngredient(name: ' onion ', measure: '5'), rice],
      recipeTitle: 'B',
    );

    expect(result.added, 1);
    expect(result.skipped, 1);
    expect(list.count, 2);
  });

  test('skips repeats inside one batch and blank names', () async {
    final list = build();
    final result = await list.addIngredients(
      [onion, onion, const RecipeIngredient(name: '  ')],
      recipeTitle: 'A',
    );
    expect(result.added, 1);
    expect(result.skipped, 1);
  });

  test('addCustom adds once and refuses blanks and repeats', () async {
    final list = build();
    expect(await list.addCustom('Milk'), isTrue);
    expect(await list.addCustom('milk'), isFalse);
    expect(await list.addCustom('   '), isFalse);
    expect(list.count, 1);
  });

  test('ticked items sink to the bottom', () async {
    final list = build();
    await list.addIngredients([onion, rice], recipeTitle: 'A');
    await list.toggle(list.items.first.id);

    expect(list.items.map((i) => i.name), ['Rice', 'Onion']);
    expect(list.checkedCount, 1);
    expect(list.remainingCount, 1);
  });

  test('setChecked ticks and unticks without flipping twice', () async {
    final list = build();
    await list.addCustom('Milk');
    final id = list.items.single.id;

    await list.setChecked(id, checked: true);
    await list.setChecked(id, checked: true);
    expect(list.items.single.checked, isTrue);

    await list.setChecked(id, checked: false);
    expect(list.items.single.checked, isFalse);
    await list.setChecked('missing', checked: true);
    expect(list.count, 1);
  });

  test('clearChecked removes only ticked items; remove drops one', () async {
    final list = build();
    await list.addIngredients([onion, rice], recipeTitle: 'A');
    await list.addCustom('Milk');
    await list.toggle(list.items.first.id);
    await list.clearChecked();
    expect(list.count, 2);

    await list.remove(list.items.first.id);
    expect(list.count, 1);
  });

  test('asText lists only what is still to buy', () async {
    final list = build();
    await list.addIngredients([onion, rice], recipeTitle: 'A');
    await list.toggle(list.items.first.id);

    final text = list.asText();
    expect(text, contains('- 200g Rice'));
    expect(text, isNot(contains('Onion')));
  });

  test('survives a restart', () async {
    final first = build();
    await first.addIngredients([onion], recipeTitle: 'A');
    await first.toggle(first.items.single.id);

    final second = build();
    expect(second.items.single.name, 'Onion');
    expect(second.items.single.checked, isTrue);
  });

  test('clear empties the list and the stored copy', () async {
    final list = build();
    await list.addCustom('Milk');
    await list.clear();
    expect(list.isEmpty, isTrue);
    expect(build().isEmpty, isTrue);
  });

  test('ignores corrupt stored data', () {
    store.data[StorageKeys.shoppingList] = '{not json';
    expect(build().isEmpty, isTrue);
  });
}
