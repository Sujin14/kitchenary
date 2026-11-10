import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kitchenary/core/constants/app_constants.dart';

// Adds each bundled font's SIL Open Font License, with its own copyright
// line, to the licence page.
abstract final class FontLicences {
  // Package name shown on the licence page -> licence asset.
  static const Map<String, String> files = {
    'DM Sans': AppAssets.dmSansLicence,
    'Fraunces': AppAssets.frauncesLicence,
  };

  static bool _registered = false;

  // Safe to call more than once; each licence is added only the first time.
  // A file is read only when the licence page asks for it.
  static void register() {
    if (_registered) return;
    _registered = true;
    for (final MapEntry(key: font, value: asset) in files.entries) {
      LicenseRegistry.addLicense(() async* {
        final text = await rootBundle.loadString(asset);
        yield LicenseEntryWithLineBreaks([font], text);
      });
    }
  }
}
