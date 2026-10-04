import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/home_controller.dart';
import 'package:kitchenary/controllers/load_status.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_category.dart';

import 'helpers/fake_recipe_service.dart';

Recipe r(String id) => Recipe(id: id, title: 'Recipe $id', imageUrl: '');

Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  late FakeRecipeService service;

  setUp(() => service = FakeRecipeService()..browseResult = [r('1'), r('2')]);

  test('starts on the Indian category and loads it', () async {
    final home = HomeController(service);
    expect(home.status, LoadStatus.loading);
    await settle();
    expect(home.status, LoadStatus.success);
    expect(home.selectedCategory, RecipeCategory.indian);
    expect(home.recipes, hasLength(2));
    home.dispose();
  });

  test('search replaces the category and clearing restores it', () async {
    service.searchResult = [r('9')];
    final home = HomeController(service);
    await settle();

    home.search('paneer');
    await settle();
    expect(service.searchCalls, ['paneer']);
    expect(home.selectedCategory, isNull);
    expect(home.isSearching, isTrue);
    expect(home.recipes.single.id, '9');

    home.clearSearch();
    await settle();
    expect(home.isSearching, isFalse);
    expect(home.selectedCategory, RecipeCategory.indian);
    home.dispose();
  });

  test('sub-chips filter and toggle off', () async {
    final home = HomeController(service);
    await settle();
    home.selectCategory(RecipeCategory.veg);
    await settle();

    final sub = RecipeCategory.veg.subcategories.first;
    home.selectSubcategory(sub);
    await settle();
    expect(home.selectedSubcategory, sub);
    expect(service.browseCalls.last, [sub]);

    home.selectSubcategory(sub);
    await settle();
    expect(home.selectedSubcategory, isNull);
    expect(service.browseCalls.last, RecipeCategory.veg.filters);
    home.dispose();
  });

  test('errors surface and retry recovers', () async {
    service.fail = true;
    final home = HomeController(service);
    await settle();
    expect(home.status, LoadStatus.error);
    expect(home.errorMessage, 'boom');

    service.fail = false;
    await home.retry();
    expect(home.status, LoadStatus.success);
    home.dispose();
  });

  test('pickRandom returns a recipe or null on failure', () async {
    service.randomResult = r('7');
    final home = HomeController(service);
    await settle();
    expect((await home.pickRandom())?.id, '7');
    service.randomResult = null;
    expect(await home.pickRandom(), isNull);
    home.dispose();
  });
}
