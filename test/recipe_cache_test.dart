import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/core/constants/storage_keys.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_filter.dart';
import 'package:kitchenary/services/memory_local_store.dart';
import 'package:kitchenary/services/recipe_cache.dart';

void main() {
  late MemoryLocalStore store;

  setUp(() => store = MemoryLocalStore());

  Recipe recipe(String id, {bool summary = false}) =>
      Recipe(id: id, title: 'R$id', imageUrl: '', isSummary: summary);

  test('keys are stable and ignore case and spaces in searches', () {
    expect(RecipeCache.searchKey(' Rice '), RecipeCache.searchKey('rice'));
    expect(
      RecipeCache.browseKey(const [RecipeFilter(FilterKind.area, 'Indian')]),
      isNot(RecipeCache.browseKey(
        const [RecipeFilter(FilterKind.category, 'Indian')],
      )),
    );
  });

  test('stores and reads a list and a single recipe', () async {
    final cache = RecipeCache(store);
    await cache.writeList('cache.browse.x', [recipe('1'), recipe('2')]);
    await cache.writeRecipe(recipe('3'));

    expect(cache.readList('cache.browse.x')!.map((r) => r.id), ['1', '2']);
    expect(cache.readRecipe('3')!.title, 'R3');
    expect(cache.readRecipe('missing'), isNull);
    expect(cache.readList('cache.nothing'), isNull);
  });

  test('survives a restart', () async {
    await RecipeCache(store).writeRecipe(recipe('1'));
    expect(RecipeCache(store).readRecipe('1')!.id, '1');
    expect(RecipeCache(store).length, 1);
  });

  test('drops the oldest entries when full', () async {
    final cache = RecipeCache(store, maxEntries: 2);
    await cache.writeRecipe(recipe('1'));
    await cache.writeRecipe(recipe('2'));
    await cache.writeRecipe(recipe('3'));

    expect(cache.length, 2);
    expect(cache.readRecipe('1'), isNull);
    expect(cache.readRecipe('3'), isNotNull);
    expect(store.data.containsKey(RecipeCache.recipeKey('1')), isFalse);
  });

  test('rewriting a key refreshes it instead of duplicating', () async {
    final cache = RecipeCache(store, maxEntries: 2);
    await cache.writeRecipe(recipe('1'));
    await cache.writeRecipe(recipe('2'));
    await cache.writeRecipe(recipe('1'));
    await cache.writeRecipe(recipe('3'));

    expect(cache.readRecipe('1'), isNotNull);
    expect(cache.readRecipe('2'), isNull);
  });

  test('allFullRecipes skips summaries', () async {
    final cache = RecipeCache(store);
    await cache.writeRecipe(recipe('1'));
    await cache.writeRecipe(recipe('2', summary: true));
    expect(cache.allFullRecipes().map((r) => r.id), ['1']);
  });

  test('clear removes everything it stored', () async {
    final cache = RecipeCache(store);
    await cache.writeRecipe(recipe('1'));
    await cache.writeList('cache.browse.x', [recipe('2')]);
    await cache.clear();

    expect(cache.length, 0);
    expect(store.data.keys.where((k) => k.startsWith(StorageKeys.cachePrefix)), isEmpty);
  });

  test('ignores a corrupt index and corrupt entries', () async {
    store.data[StorageKeys.cacheIndex] = '{bad';
    store.data[RecipeCache.recipeKey('1')] = '{bad';
    final cache = RecipeCache(store);
    expect(cache.length, 0);
    expect(cache.readRecipe('1'), isNull);
  });

  test('readAnyBrowse merges saved feeds, newest first, without repeats',
      () async {
    final cache = RecipeCache(store);
    await cache.writeList('cache.browse.a', [recipe('1'), recipe('2')]);
    await cache.writeList('cache.browse.b', [recipe('2'), recipe('3')]);
    await cache.writeList('cache.search.x', [recipe('9')]);

    expect(cache.readAnyBrowse()!.map((r) => r.id), ['2', '3', '1']);
    expect(cache.readAnyBrowse(limit: 2)!.map((r) => r.id), ['2', '3']);
    expect(RecipeCache(MemoryLocalStore()).readAnyBrowse(), isNull);
  });
}
