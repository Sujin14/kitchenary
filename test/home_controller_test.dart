import 'dart:math';

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

  test('starts on a random mix with no category chosen', () async {
    final home = HomeController(service, random: Random(1));
    expect(home.status, LoadStatus.loading);
    await settle();
    expect(home.status, LoadStatus.success);
    expect(home.selectedCategory, isNull);
    expect(home.isMixed, isTrue);
    expect(home.recipes, hasLength(2));

    final filters = service.browseCalls.single;
    expect(filters, hasLength(HomeController.mixSize));
    expect(filters.toSet(), hasLength(HomeController.mixSize));
    expect(RecipeCategory.mixPool, containsAll(filters));
    home.dispose();
  });

  test('refreshing the mix picks other categories', () async {
    final home = HomeController(service, random: Random(2));
    await settle();
    await home.retry();
    expect(service.browseCalls, hasLength(2));
    expect(service.browseCalls[0], isNot(service.browseCalls[1]));
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
    expect(home.isMixed, isTrue);
    expect(service.browseCalls.last, hasLength(HomeController.mixSize));
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

  test('Veg pill selects, then clears a sub-filter, then resets', () async {
    final home = HomeController(service);
    await settle();

    home.toggleDiet(RecipeCategory.veg);
    await settle();
    expect(home.selectedCategory, RecipeCategory.veg);
    expect(home.hasActiveFilter, isFalse);

    final sub = RecipeCategory.veg.subcategories.first;
    home.applyFilter(RecipeCategory.veg, sub);
    await settle();
    expect(home.selectedSubcategory, sub);
    expect(home.hasActiveFilter, isTrue);

    home.toggleDiet(RecipeCategory.veg);
    await settle();
    expect(home.selectedCategory, RecipeCategory.veg);
    expect(home.selectedSubcategory, isNull);

    home.toggleDiet(RecipeCategory.veg);
    await settle();
    expect(home.selectedCategory, isNull);
    expect(home.isMixed, isTrue);
    home.dispose();
  });

  test('switching between Veg and Non-veg replaces the feed', () async {
    final home = HomeController(service);
    await settle();
    home.toggleDiet(RecipeCategory.veg);
    await settle();
    home.toggleDiet(RecipeCategory.nonVeg);
    await settle();

    expect(home.selectedCategory, RecipeCategory.nonVeg);
    expect(service.browseCalls.last, RecipeCategory.nonVeg.filters);
    home.dispose();
  });

  test('filter sheet choices apply and clearFilters resets', () async {
    final home = HomeController(service);
    await settle();
    expect(home.hasActiveFilter, isFalse);

    home.applyFilter(RecipeCategory.indian);
    await settle();
    expect(home.hasActiveFilter, isTrue);
    expect(service.browseCalls.last, RecipeCategory.indian.filters);

    home.applyFilter(RecipeCategory.dessert);
    await settle();
    expect(home.hasActiveFilter, isTrue);
    expect(service.browseCalls.last, RecipeCategory.dessert.filters);

    final meat = RecipeCategory.nonVeg.subcategories.first;
    home.applyFilter(RecipeCategory.nonVeg, meat);
    await settle();
    expect(service.browseCalls.last, [meat]);

    home.clearFilters();
    await settle();
    expect(home.isMixed, isTrue);
    expect(home.hasActiveFilter, isFalse);
    home.dispose();
  });

  test('searching shows no pill and no filter', () async {
    service.searchResult = [r('9')];
    final home = HomeController(service);
    await settle();
    home.search('dal');
    await settle();
    expect(home.selectedCategory, isNull);
    expect(home.hasActiveFilter, isFalse);
    home.dispose();
  });
}
