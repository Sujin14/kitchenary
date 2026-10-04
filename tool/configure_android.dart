// Run once after `flutter create`:  dart run tool/configure_android.dart
//
// Patches android/app/src/main/AndroidManifest.xml so the release build can
// reach the internet and open web links. Safe to run more than once.
import 'dart:io';

const String appLabel = 'Kitchenary';

void main() {
  final file = File('android/app/src/main/AndroidManifest.xml');
  if (!file.existsSync()) {
    stderr.writeln('AndroidManifest.xml not found. Run `flutter create` first.');
    exit(1);
  }

  var xml = file.readAsStringSync();
  final original = xml;

  // 1. App label shown under the launcher icon.
  xml = xml.replaceFirst(RegExp(r'android:label="[^"]*"'), 'android:label="$appLabel"');

  // 2. Internet permission (the default template only adds it for debug).
  if (!xml.contains('android.permission.INTERNET')) {
    xml = xml.replaceFirst(
      '<application',
      '<uses-permission android:name="android.permission.INTERNET"/>\n    <application',
    );
  }

  // 3. Let url_launcher check for apps that can open https and mailto links.
  if (!xml.contains('<queries>')) {
    const queries = '''
    <queries>
        <intent>
            <action android:name="android.intent.action.VIEW"/>
            <data android:scheme="https"/>
        </intent>
        <intent>
            <action android:name="android.intent.action.SENDTO"/>
            <data android:scheme="mailto"/>
        </intent>
    </queries>
''';
    xml = xml.replaceFirst('</manifest>', '$queries</manifest>');
  }

  if (xml == original) {
    stdout.writeln('AndroidManifest.xml already configured.');
  } else {
    file.writeAsStringSync(xml);
    stdout.writeln('AndroidManifest.xml updated.');
  }
}
