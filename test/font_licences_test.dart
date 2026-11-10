import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/core/utils/font_licences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const copyrightLines = {
    'DM Sans': 'Copyright 2014 The DM Sans Project Authors',
    'Fraunces': 'Copyright 2018 The Fraunces Project Authors',
  };

  test('registers one OFL entry per font, each with its own copyright', () async {
    FontLicences.register();
    FontLicences.register();

    final entries = await LicenseRegistry.licenses
        .where((e) => e.packages.any(copyrightLines.containsKey))
        .toList();

    expect(entries, hasLength(2));
    for (final MapEntry(key: font, value: copyright) in copyrightLines.entries) {
      final entry = entries.singleWhere((e) => e.packages.contains(font));
      expect(entry.packages, [font]);
      final text = entry.paragraphs.map((p) => p.text).join('\n');
      expect(text, contains('SIL Open Font License'));
      expect(text, contains(copyright));
      for (final other in copyrightLines.values.where((c) => c != copyright)) {
        expect(text, isNot(contains(other)), reason: font);
      }
    }
  });
}
