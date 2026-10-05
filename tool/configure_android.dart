// Run once after `flutter create`:  dart run tool/configure_android.dart
//
// Patches android/app/src/main/AndroidManifest.xml so the release build can
// reach the internet, open web links and ring cooking timers (notification
// permissions, the plugin's receivers and the Java desugaring that
// flutter_local_notifications needs).
// Safe to run more than once.
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

  // 4. Permissions for cooking-timer notifications.
  for (final permission in const [
    'android.permission.POST_NOTIFICATIONS',
    'android.permission.VIBRATE',
    'android.permission.SCHEDULE_EXACT_ALARM',
    'android.permission.RECEIVE_BOOT_COMPLETED',
  ]) {
    if (!xml.contains(permission)) {
      xml = xml.replaceFirst(
        '<application',
        '<uses-permission android:name="$permission"/>\n    <application',
      );
    }
  }

  // 5. flutter_local_notifications does not declare its receivers itself;
  // without them a scheduled timer notification is never shown.
  if (!xml.contains('ScheduledNotificationReceiver')) {
    const receivers = '''
        <receiver
            android:exported="false"
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
        <receiver
            android:exported="false"
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
''';
    xml = xml.replaceFirst('</application>', '$receivers    </application>');
  }

  if (xml == original) {
    stdout.writeln('AndroidManifest.xml already configured.');
  } else {
    file.writeAsStringSync(xml);
    stdout.writeln('AndroidManifest.xml updated.');
  }

  _configureGradle();
}

/// flutter_local_notifications needs core library desugaring.
void _configureGradle() {
  const desugarVersion = '2.1.5';
  final kts = File('android/app/build.gradle.kts');
  final groovy = File('android/app/build.gradle');

  if (kts.existsSync()) {
    var text = kts.readAsStringSync();
    if (text.contains('coreLibraryDesugaring')) {
      stdout.writeln('Gradle already configured for desugaring.');
      return;
    }
    if (!text.contains('compileOptions {')) {
      stderr.writeln('Could not find compileOptions in build.gradle.kts. '
          'Add desugaring by hand (see README).');
      return;
    }
    text = text.replaceFirst('compileOptions {',
        'compileOptions {\n        isCoreLibraryDesugaringEnabled = true');
    text += '\ndependencies {\n'
        '    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:$desugarVersion")\n'
        '}\n';
    kts.writeAsStringSync(text);
    stdout.writeln('build.gradle.kts updated (desugaring).');
  } else if (groovy.existsSync()) {
    var text = groovy.readAsStringSync();
    if (text.contains('coreLibraryDesugaring')) {
      stdout.writeln('Gradle already configured for desugaring.');
      return;
    }
    if (!text.contains('compileOptions {')) {
      stderr.writeln('Could not find compileOptions in build.gradle. '
          'Add desugaring by hand (see README).');
      return;
    }
    text = text.replaceFirst('compileOptions {',
        'compileOptions {\n        coreLibraryDesugaringEnabled true');
    text += "\ndependencies {\n"
        "    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:$desugarVersion'\n"
        "}\n";
    groovy.writeAsStringSync(text);
    stdout.writeln('build.gradle updated (desugaring).');
  } else {
    stderr.writeln('android/app/build.gradle(.kts) not found.');
  }
}
