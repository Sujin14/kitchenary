import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kitchenary/models/recipe_filter.dart';
import 'package:kitchenary/services/api_exception.dart';
import 'package:kitchenary/services/mealdb_recipe_service.dart';

MealDbRecipeService serviceWith(http.Response Function(http.Request) handler) =>
    MealDbRecipeService(
      baseUrl: 'https://example.test/api',
      client: MockClient((request) async => handler(request)),
    );

http.Response json(Object body, [int status = 200]) =>
    http.Response(jsonEncode(body), status);

void main() {
  test('search returns full recipes and handles null meals', () async {
    final service = serviceWith((request) {
      expect(request.url.path, '/api/search.php');
      expect(request.url.queryParameters['s'], 'rice');
      return json({
        'meals': [
          {'idMeal': '1', 'strMeal': 'Rice', 'strIngredient1': 'rice'},
        ],
      });
    });
    final result = await service.search('rice');
    expect(result.single.title, 'Rice');
    expect(result.single.isSummary, isFalse);

    final empty = serviceWith((_) => json({'meals': null}));
    expect(await empty.search('zzz'), isEmpty);
  });

  test('browse interleaves filters and removes duplicates', () async {
    final service = serviceWith((request) {
      final c = request.url.queryParameters['c'];
      final ids = c == 'A' ? ['1', '2', '3'] : ['2', '4'];
      return json({
        'meals': [
          for (final id in ids)
            {'idMeal': id, 'strMeal': 'm$id', 'strMealThumb': ''},
        ],
      });
    });
    final result = await service.browse(const [
      RecipeFilter(FilterKind.category, 'A'),
      RecipeFilter(FilterKind.category, 'B'),
    ]);
    expect(result.map((r) => r.id), ['1', '2', '4', '3']);
    expect(result.every((r) => r.isSummary), isTrue);
  });

  test('ingredient filters replace spaces with underscores', () async {
    String? seen;
    final service = serviceWith((request) {
      seen = request.url.queryParameters['i'];
      return json({'meals': null});
    });
    await service.browse(
      const [RecipeFilter(FilterKind.ingredient, 'chicken breast')],
    );
    expect(seen, 'chicken_breast');
  });

  test('lookup caches full recipes', () async {
    var calls = 0;
    final service = serviceWith((_) {
      calls++;
      return json({
        'meals': [
          {'idMeal': '9', 'strMeal': 'Dal'},
        ],
      });
    });
    expect((await service.lookup('9'))?.title, 'Dal');
    expect((await service.lookup('9'))?.title, 'Dal');
    expect(calls, 1);
  });

  test('server errors become ApiException', () async {
    final service = serviceWith((_) => json({}, 500));
    expect(service.search('x'), throwsA(isA<ApiException>()));
  });

  test('transport failures become ApiException', () async {
    final service = MealDbRecipeService(
      baseUrl: 'https://example.test/api',
      client: MockClient((_) async => throw http.ClientException('offline')),
    );
    expect(service.random(), throwsA(isA<ApiException>()));
  });
}
