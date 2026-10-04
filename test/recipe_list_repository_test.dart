import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/services/memory_local_store.dart';
import 'package:kitchenary/services/recipe_list_repository.dart';

void main() {
  late MemoryLocalStore store;
  late RecipeListRepository repository;

  setUp(() {
    store = MemoryLocalStore();
    repository = RecipeListRepository(store, 'k');
  });

  test('returns an empty list when nothing is stored', () {
    expect(repository.load(), isEmpty);
  });

  test('round-trips recipes', () async {
    await repository.save(const [
      Recipe(id: '1', title: 'Dal', imageUrl: 'a'),
      Recipe(id: '2', title: 'Rice', imageUrl: 'b'),
    ]);
    expect(repository.load().map((r) => r.title), ['Dal', 'Rice']);
  });

  test('ignores corrupt or unexpected data instead of crashing', () {
    store.data['k'] = 'not json {';
    expect(repository.load(), isEmpty);

    store.data['k'] = '{"a": 1}';
    expect(repository.load(), isEmpty);

    store.data['k'] = '[1, "x", {"title": "No id"}]';
    expect(repository.load(), isEmpty);
  });

  test('clear removes the stored data', () async {
    await repository.save(const [Recipe(id: '1', title: 'Dal', imageUrl: '')]);
    await repository.clear();
    expect(repository.load(), isEmpty);
  });
}
