import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kitchenary/core/constants/api_constants.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_filter.dart';
import 'package:kitchenary/services/api_exception.dart';
import 'package:kitchenary/services/recipe_service.dart';

/// [RecipeService] backed by TheMealDB's JSON API.
class MealDbRecipeService implements RecipeService {
  MealDbRecipeService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConstants.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  static const Duration _timeout = Duration(seconds: 15);

  /// Full recipes already fetched in this session.
  final Map<String, Recipe> _fullRecipes = {};

  @override
  Future<List<Recipe>> search(String query) async {
    final meals = await _getMeals('search.php', {'s': query});
    final recipes = meals.map(Recipe.fromMealDb).toList();
    for (final r in recipes) {
      _fullRecipes[r.id] = r;
    }
    return recipes;
  }

  @override
  Future<List<Recipe>> browse(List<RecipeFilter> filters) async {
    final lists = await Future.wait(filters.map(_runFilter));

    // Interleave so every filter is represented, then de-duplicate.
    final merged = <Recipe>[];
    final seen = <String>{};
    final longest = lists.fold<int>(0, (m, l) => l.length > m ? l.length : m);
    for (var i = 0; i < longest; i++) {
      for (final list in lists) {
        if (i >= list.length) continue;
        final recipe = list[i];
        if (recipe.id.isNotEmpty && seen.add(recipe.id)) merged.add(recipe);
        if (merged.length >= AppConstants.feedLimit) return merged;
      }
    }
    return merged;
  }

  Future<List<Recipe>> _runFilter(RecipeFilter filter) async {
    switch (filter.kind) {
      case FilterKind.search:
        return search(filter.value);
      case FilterKind.category:
        return _summaries({'c': filter.value});
      case FilterKind.area:
        return _summaries({'a': filter.value});
      case FilterKind.ingredient:
        return _summaries({'i': filter.value.replaceAll(' ', '_')});
    }
  }

  Future<List<Recipe>> _summaries(Map<String, String> query) async {
    final meals = await _getMeals('filter.php', query);
    return meals.map(Recipe.summaryFromMealDb).toList();
  }

  @override
  Future<Recipe?> lookup(String id) async {
    final cached = _fullRecipes[id];
    if (cached != null) return cached;
    final meals = await _getMeals('lookup.php', {'i': id});
    if (meals.isEmpty) return null;
    final recipe = Recipe.fromMealDb(meals.first);
    _fullRecipes[recipe.id] = recipe;
    return recipe;
  }

  @override
  Future<Recipe?> random() async {
    final meals = await _getMeals('random.php', const {});
    if (meals.isEmpty) return null;
    final recipe = Recipe.fromMealDb(meals.first);
    _fullRecipes[recipe.id] = recipe;
    return recipe;
  }

  /// Calls [endpoint] and returns the `meals` array (empty when null).
  Future<List<Map<String, dynamic>>> _getMeals(
    String endpoint,
    Map<String, String> query,
  ) async {
    final uri = Uri.parse('$_baseUrl/$endpoint').replace(
      queryParameters: query.isEmpty ? null : query,
    );

    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode != 200) {
        throw ApiException(_messageForStatus(response.statusCode));
      }
      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) return const [];
      final meals = data['meals'];
      if (meals is! List) return const [];
      return meals.whereType<Map<String, dynamic>>().toList();
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('The request timed out. Please try again.');
    } on http.ClientException {
      throw const ApiException('No internet connection.');
    } on FormatException {
      throw const ApiException('Received an unexpected response.');
    } catch (_) {
      // dart:io SocketException and other transport failures.
      throw const ApiException('No internet connection.');
    }
  }

  String _messageForStatus(int status) {
    if (status == 429) return 'Too many requests. Please wait a moment.';
    if (status >= 500) return 'The recipe service is having trouble.';
    return 'Could not load recipes (error $status).';
  }

  @override
  void dispose() => _client.close();
}
