import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_filter.dart';

/// Where recipes come from. Controllers depend on this interface only, so the
/// source (TheMealDB today) can be replaced without touching any screen.
abstract interface class RecipeService {
  /// Full recipes whose name matches [query].
  Future<List<Recipe>> search(String query);

  /// Summary recipes matching any of [filters], interleaved and de-duplicated.
  Future<List<Recipe>> browse(List<RecipeFilter> filters);

  /// The full recipe with [id], or null when it does not exist.
  Future<Recipe?> lookup(String id);

  /// A random full recipe.
  Future<Recipe?> random();

  void dispose();
}
