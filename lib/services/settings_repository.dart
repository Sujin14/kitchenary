import 'package:flutter/material.dart';
import 'package:kitchenary/core/constants/storage_keys.dart';
import 'package:kitchenary/services/local_store.dart';

/// Reads and writes the user's settings.
class SettingsRepository {
  const SettingsRepository(this._store);

  final LocalStore _store;

  bool get onboardingDone => _store.read(StorageKeys.onboardingDone) == '1';

  String get userName => _store.read(StorageKeys.userName) ?? '';

  ThemeMode get themeMode {
    final name = _store.read(StorageKeys.themeMode);
    return ThemeMode.values.asNameMap()[name] ?? ThemeMode.system;
  }

  Future<void> setOnboardingDone() =>
      _store.write(StorageKeys.onboardingDone, '1');

  Future<void> setUserName(String value) =>
      _store.write(StorageKeys.userName, value);

  Future<void> setThemeMode(ThemeMode value) =>
      _store.write(StorageKeys.themeMode, value.name);

  /// Forgets the name and theme choice. Onboarding stays done.
  Future<void> reset() async {
    await _store.remove(StorageKeys.userName);
    await _store.remove(StorageKeys.themeMode);
  }
}
