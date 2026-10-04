import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/history_controller.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/core/constants/storage_keys.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/services/memory_local_store.dart';
import 'package:kitchenary/services/recipe_list_repository.dart';

void main() {
  late MemoryLocalStore store;

  HistoryController build() => HistoryController(
        RecipeListRepository(store, StorageKeys.history),
      );

  Recipe recipe(String id) => Recipe(id: id, title: 'Recipe $id', imageUrl: '');

  setUp(() => store = MemoryLocalStore());

  test('newest first, and viewing a recipe again moves it to the top', () async {
    final history = build();
    await history.record(recipe('1'));
    await history.record(recipe('2'));
    await history.record(recipe('1'));
    expect(history.recipes.map((r) => r.id), ['1', '2']);
  });

  test('summaries and own recipes are not recorded', () async {
    final history = build();
    await history.record(
      const Recipe(id: '1', title: 'Dal', imageUrl: '', isSummary: true),
    );
    await history.record(
      const Recipe(id: 'own_5', title: 'Mine', imageUrl: ''),
    );
    expect(history.isEmpty, isTrue);
  });

  test('keeps only the most recent entries', () async {
    final history = build();
    for (var i = 0; i < AppConstants.historyLimit + 5; i++) {
      await history.record(recipe('$i'));
    }
    expect(history.count, AppConstants.historyLimit);
    expect(history.recipes.first.id, '${AppConstants.historyLimit + 4}');
  });

  test('is remembered across restarts and can be cleared', () async {
    final history = build();
    await history.record(recipe('1'));
    expect(build().count, 1);

    await history.clear();
    expect(history.isEmpty, isTrue);
    expect(build().isEmpty, isTrue);
  });
}
