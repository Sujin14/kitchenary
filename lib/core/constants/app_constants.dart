/// App-wide constants. Nothing here depends on Flutter.
abstract final class AppConstants {
  static const String appName = 'Kitchenary';
  static const String tagline = 'Learn it. Shop it. Cook it.';

  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration searchDebounce = Duration(milliseconds: 500);

  /// Maximum recipes shown in one feed.
  static const int feedLimit = 24;
}

/// Asset paths. Keep in sync with `pubspec.yaml`.
abstract final class AppAssets {
  static const String logoMark = 'assets/images/kitchenary_mark.png';
}
