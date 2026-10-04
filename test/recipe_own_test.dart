import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/models/diet_type.dart';
import 'package:kitchenary/models/recipe.dart';

void main() {
  test('own recipes are recognised by id and labelled "My recipe"', () {
    const own = Recipe(id: 'own_1', title: 'Mine', imageUrl: '');
    const api = Recipe(id: '52772', title: 'Theirs', imageUrl: '');
    expect(own.isOwn, isTrue);
    expect(own.sourceLabel, 'My recipe');
    expect(api.isOwn, isFalse);
  });

  test('a custom diet overrides the one inferred from the category', () {
    const inferred = Recipe(id: '1', title: 'x', imageUrl: '', category: 'Beef');
    const custom = Recipe(
      id: '2',
      title: 'x',
      imageUrl: '',
      category: 'Beef',
      customDiet: DietType.vegan,
    );
    expect(inferred.diet, DietType.nonVeg);
    expect(custom.diet, DietType.vegan);
  });

  test('custom diet survives toJson / fromJson; absent stays null', () {
    const withDiet = Recipe(
      id: 'own_1',
      title: 'x',
      imageUrl: '',
      customDiet: DietType.nonVeg,
    );
    expect(Recipe.fromJson(withDiet.toJson()).customDiet, DietType.nonVeg);

    const without = Recipe(id: '1', title: 'x', imageUrl: '');
    expect(without.toJson().containsKey('customDiet'), isFalse);
    expect(Recipe.fromJson(without.toJson()).customDiet, isNull);
  });
}
