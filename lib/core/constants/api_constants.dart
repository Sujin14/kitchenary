/// TheMealDB configuration.
///
/// The free test key `1` is for development and testing. Before a public
/// release, read https://www.themealdb.com/api.php and, if required, supply a
/// supporter key at build time:
///
///     flutter run --dart-define=MEALDB_API_KEY=your-key
abstract final class ApiConstants {
  static const String apiKey = String.fromEnvironment(
    'MEALDB_API_KEY',
    defaultValue: '1',
  );

  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/$apiKey';
}
