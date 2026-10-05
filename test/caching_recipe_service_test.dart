import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/offline_status_controller.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_filter.dart';
import 'package:kitchenary/services/api_exception.dart';
import 'package:kitchenary/services/caching_recipe_service.dart';
import 'package:kitchenary/services/memory_local_store.dart';
import 'package:kitchenary/services/recipe_cache.dart';

import 'helpers/fake_recipe_service.dart';

/// Fake whose random() can fail like a lost connection.
class _RandomFailingService extends FakeRecipeService {
  @override
  Future<Recipe?> random() async {
    if (this.fail) throw const ApiException('offline');
    return randomResult;
  }
}

void main() {
  late FakeRecipeService inner;
  late RecipeCache cache;
  late OfflineStatusController status;
  late CachingRecipeService service;

  const filters = [RecipeFilter(FilterKind.area, 'Indian')];
  const summary = Recipe(id: '1', title: 'Dal', imageUrl: '', isSummary: true);
  const full = Recipe(id: '1', title: 'Dal', imageUrl: '');

  setUp(() {
    inner = _RandomFailingService();
    cache = RecipeCache(MemoryLocalStore());
    status = OfflineStatusController();
    service = CachingRecipeService(inner, cache, status, random: Random(1));
  });

  test('browse passes results through and saves them', () async {
    inner.browseResult = [summary];
    expect((await service.browse(filters)).single.id, '1');
    expect(status.isOffline, isFalse);

    inner.fail = true;
    final offline = await service.browse(filters);
    expect(offline.single.id, '1');
    expect(status.isOffline, isTrue);
  });

  test('browse fails when offline and nothing was saved', () async {
    inner.fail = true;
    expect(() => service.browse(filters), throwsA(isA<ApiException>()));
    expect(status.isOffline, isFalse);
  });

  test('an unseen feed falls back to any saved feed when offline', () async {
    inner.browseResult = [summary];
    await service.browse(filters);

    inner.fail = true;
    final other = await service.browse(const [
      RecipeFilter(FilterKind.category, 'Dessert'),
    ]);
    expect(other.single.id, '1');
    expect(status.isOffline, isTrue);
  });

  test('going online again clears the offline flag', () async {
    inner.browseResult = [summary];
    await service.browse(filters);
    inner.fail = true;
    await service.browse(filters);
    expect(status.isOffline, isTrue);

    inner.fail = false;
    await service.browse(filters);
    expect(status.isOffline, isFalse);
  });

  test('search saves results and each full recipe', () async {
    inner.searchResult = [full];
    await service.search('dal');
    expect(cache.readRecipe('1'), isNotNull);

    inner.fail = true;
    expect((await service.search(' DAL ')).single.title, 'Dal');
  });

  test('lookup uses the saved full recipe without asking the service', () async {
    inner.lookupResult = full;
    expect((await service.lookup('1'))!.title, 'Dal');

    inner.fail = true;
    expect((await service.lookup('1'))!.title, 'Dal');
  });

  test('lookup does not trust a saved summary', () async {
    await cache.writeRecipe(summary);
    inner.lookupResult = full;
    final result = await service.lookup('1');
    expect(result!.isSummary, isFalse);
    expect(cache.readRecipe('1')!.isSummary, isFalse);
  });

  test('lookup of an unseen recipe fails offline', () async {
    inner.fail = true;
    expect(() => service.lookup('9'), throwsA(isA<ApiException>()));
  });

  test('random falls back to a saved recipe when offline', () async {
    inner.randomResult = full;
    await service.random();

    inner.fail = true;
    expect((await service.random())!.id, '1');
    expect(status.isOffline, isTrue);
  });

  test('random fails offline when nothing is saved', () async {
    inner.fail = true;
    expect(() => service.random(), throwsA(isA<ApiException>()));
  });
}
