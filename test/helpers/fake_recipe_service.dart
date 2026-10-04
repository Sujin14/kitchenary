import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_filter.dart';
import 'package:kitchenary/services/api_exception.dart';
import 'package:kitchenary/services/recipe_service.dart';

/// In-memory [RecipeService] for controller tests.
class FakeRecipeService implements RecipeService {
  List<Recipe> browseResult = const [];
  List<Recipe> searchResult = const [];
  Recipe? lookupResult;
  Recipe? randomResult;
  bool fail = false;

  final List<List<RecipeFilter>> browseCalls = [];
  final List<String> searchCalls = [];

  @override
  Future<List<Recipe>> browse(List<RecipeFilter> filters) async {
    browseCalls.add(filters);
    if (fail) throw const ApiException('boom');
    return browseResult;
  }

  @override
  Future<List<Recipe>> search(String query) async {
    searchCalls.add(query);
    if (fail) throw const ApiException('boom');
    return searchResult;
  }

  @override
  Future<Recipe?> lookup(String id) async {
    if (fail) throw const ApiException('boom');
    return lookupResult;
  }

  @override
  Future<Recipe?> random() async => randomResult;

  @override
  void dispose() {}
}
