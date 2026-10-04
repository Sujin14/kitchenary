import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/load_status.dart';
import 'package:kitchenary/controllers/recipe_details_controller.dart';
import 'package:kitchenary/models/recipe.dart';

import 'helpers/fake_recipe_service.dart';

Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  late FakeRecipeService service;

  setUp(() => service = FakeRecipeService());

  test('a full recipe is shown immediately without a request', () {
    const full = Recipe(id: '1', title: 'Dal', imageUrl: '');
    final details = RecipeDetailsController(service, full);
    expect(details.status, LoadStatus.success);
    expect(details.recipe.title, 'Dal');
    details.dispose();
  });

  test('a summary is replaced by the full recipe once loaded', () async {
    const summary = Recipe(id: '1', title: 'Dal', imageUrl: '', isSummary: true);
    service.lookupResult = const Recipe(
      id: '1',
      title: 'Dal Tadka',
      imageUrl: '',
      steps: ['Boil', 'Temper'],
    );
    final details = RecipeDetailsController(service, summary);
    expect(details.status, LoadStatus.loading);
    await settle();
    expect(details.status, LoadStatus.success);
    expect(details.recipe.title, 'Dal Tadka');
    expect(details.recipe.hasSteps, isTrue);
    details.dispose();
  });

  test('a missing recipe and a failure both end in an error', () async {
    const summary = Recipe(id: '9', title: '', imageUrl: '', isSummary: true);
    final details = RecipeDetailsController(service, summary);
    await settle();
    expect(details.status, LoadStatus.error);
    expect(details.errorMessage, contains('no longer available'));

    service.fail = true;
    await details.load();
    expect(details.status, LoadStatus.error);
    expect(details.errorMessage, 'boom');
    details.dispose();
  });
}
