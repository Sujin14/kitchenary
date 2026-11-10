// App-wide constants. Nothing here depends on Flutter.
abstract final class AppConstants {
  static const String appName = 'Kitchenary';
  static const String tagline = 'Learn it. Shop it. Cook it.';

  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration searchDebounce = Duration(milliseconds: 500);

  // Maximum recipes shown in one feed.
  static const int feedLimit = 24;

  // Recently viewed recipes kept on the device.
  static const int historyLimit = 30;

  // Shown on the Profile screen. Keep in sync with `pubspec.yaml`.
  static const String appVersion = '1.0.0';

  // Name of the on-device database box.
  static const String storageBox = 'kitchenary';

  // The one support address. Shown in the Privacy Policy, Terms and About
  // pages; use this constant everywhere instead of writing the address.
  static const String supportEmail = 'sujinksureshofcl@gmail.com';
}

// Asset paths. Keep in sync with `pubspec.yaml`.
abstract final class AppAssets {
  static const String logoMark = 'assets/images/kitchenary_mark.png';
  static const String dmSansLicence = 'assets/fonts/OFL-DMSans.txt';
  static const String frauncesLicence = 'assets/fonts/OFL-Fraunces.txt';
}
