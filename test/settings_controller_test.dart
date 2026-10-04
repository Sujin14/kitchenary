import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/settings_controller.dart';
import 'package:kitchenary/services/memory_local_store.dart';
import 'package:kitchenary/services/settings_repository.dart';

void main() {
  late MemoryLocalStore store;

  SettingsController build() => SettingsController(SettingsRepository(store));

  setUp(() => store = MemoryLocalStore());

  test('starts with defaults on a fresh install', () {
    final settings = build();
    expect(settings.onboardingDone, isFalse);
    expect(settings.hasName, isFalse);
    expect(settings.initial, '');
    expect(settings.themeMode, ThemeMode.system);
  });

  test('completing onboarding is remembered across restarts', () async {
    final settings = build();
    await settings.completeOnboarding();
    expect(settings.onboardingDone, isTrue);
    expect(build().onboardingDone, isTrue);
  });

  test('name is trimmed, stored and gives an upper-case initial', () async {
    final settings = build();
    await settings.setUserName('  asha ');
    expect(settings.userName, 'asha');
    expect(settings.initial, 'A');
    expect(build().userName, 'asha');
  });

  test('theme mode is remembered', () async {
    final settings = build();
    await settings.setThemeMode(ThemeMode.dark);
    expect(build().themeMode, ThemeMode.dark);
  });

  test('reset forgets name and theme but keeps onboarding done', () async {
    final settings = build();
    await settings.completeOnboarding();
    await settings.setUserName('Asha');
    await settings.setThemeMode(ThemeMode.dark);

    await settings.reset();

    final fresh = build();
    expect(fresh.userName, '');
    expect(fresh.themeMode, ThemeMode.system);
    expect(fresh.onboardingDone, isTrue);
  });

  test('listeners are told about changes', () async {
    final settings = build();
    var calls = 0;
    settings.addListener(() => calls++);
    await settings.setThemeMode(ThemeMode.light);
    await settings.setThemeMode(ThemeMode.light); // no change, no call
    expect(calls, 1);
  });
}
