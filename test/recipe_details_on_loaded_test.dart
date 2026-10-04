import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/recipe_details_controller.dart';
import 'package:kitchenary/models/recipe.dart';

import 'helpers/fake_recipe_service.dart';

Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  test('onLoaded fires for a full recipe, after construction', () async {
    final loaded = <Recipe>[];
    const full = Recipe(id: '1', title: 'Dal', imageUrl: '');
    final details = RecipeDetailsController(
      FakeRecipeService(),
      full,
      onLoaded: loaded.add,
    );
    expect(loaded, isEmpty); // deferred, never during build
    await settle();
    expect(loaded.single.id, '1');
    details.dispose();
  });

  test('onLoaded fires with the full recipe after a lookup', () async {
    final service = FakeRecipeService()
      ..lookupResult = const Recipe(id: '1', title: 'Dal Tadka', imageUrl: '');
    final loaded = <Recipe>[];
    final details = RecipeDetailsController(
      service,
      const Recipe(id: '1', title: 'Dal', imageUrl: '', isSummary: true),
      onLoaded: loaded.add,
    );
    await settle();
    await settle();
    expect(loaded.single.title, 'Dal Tadka');
    details.dispose();
  });

  test('onLoaded does not fire when the lookup fails', () async {
    final service = FakeRecipeService()..fail = true;
    final loaded = <Recipe>[];
    final details = RecipeDetailsController(
      service,
      const Recipe(id: '1', title: 'Dal', imageUrl: '', isSummary: true),
      onLoaded: loaded.add,
    );
    await settle();
    await settle();
    expect(loaded, isEmpty);
    details.dispose();
  });
}
