import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/saved_recipes_controller.dart';
import 'package:kitchenary/core/constants/storage_keys.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/services/memory_local_store.dart';
import 'package:kitchenary/services/recipe_list_repository.dart';

void main() {
  late MemoryLocalStore store;

  SavedRecipesController build() => SavedRecipesController(
        RecipeListRepository(store, StorageKeys.savedRecipes),
      );

  const dal = Recipe(id: '1', title: 'Dal', imageUrl: '');
  const rice = Recipe(id: '2', title: 'Rice', imageUrl: '');

  setUp(() => store = MemoryLocalStore());

  test('starts empty', () {
    final saved = build();
    expect(saved.isEmpty, isTrue);
    expect(saved.isSaved('1'), isFalse);
  });

  test('toggle saves, newest first, and removes on the second call', () async {
    final saved = build();
    expect(await saved.toggle(dal), isTrue);
    expect(await saved.toggle(rice), isTrue);
    expect(saved.recipes.map((r) => r.id), ['2', '1']);
    expect(saved.isSaved('1'), isTrue);

    expect(await saved.toggle(dal), isFalse);
    expect(saved.recipes.map((r) => r.id), ['2']);
    expect(saved.isSaved('1'), isFalse);
  });

  test('saved recipes survive a restart, with their details', () async {
    final saved = build();
    await saved.toggle(
      const Recipe(
        id: '9',
        title: 'Khichdi',
        imageUrl: 'x',
        steps: ['Cook'],
      ),
    );
    final again = build();
    expect(again.count, 1);
    expect(again.recipes.single.title, 'Khichdi');
    expect(again.recipes.single.steps, ['Cook']);
  });

  test('refresh upgrades a saved summary to the full recipe', () async {
    final saved = build();
    await saved.toggle(
      const Recipe(id: '1', title: 'Dal', imageUrl: '', isSummary: true),
    );
    await saved.refresh(
      const Recipe(id: '1', title: 'Dal Tadka', imageUrl: '', steps: ['Boil']),
    );
    expect(saved.recipes.single.title, 'Dal Tadka');
    expect(saved.recipes.single.isSummary, isFalse);
    expect(build().recipes.single.steps, ['Boil']);
  });

  test('refresh ignores recipes that are not saved or are summaries', () async {
    final saved = build();
    await saved.refresh(dal);
    expect(saved.isEmpty, isTrue);

    await saved.toggle(dal);
    await saved.refresh(
      const Recipe(id: '1', title: 'Other', imageUrl: '', isSummary: true),
    );
    expect(saved.recipes.single.title, 'Dal');
  });

  test('clear empties the list and the store', () async {
    final saved = build();
    await saved.toggle(dal);
    await saved.clear();
    expect(saved.isEmpty, isTrue);
    expect(build().isEmpty, isTrue);
  });
}
