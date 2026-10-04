import 'package:flutter/material.dart';
import 'package:kitchenary/services/settings_repository.dart';

/// The user's name, theme choice and whether onboarding has been seen.
class SettingsController extends ChangeNotifier {
  SettingsController(this._repository)
      : _onboardingDone = _repository.onboardingDone,
        _userName = _repository.userName,
        _themeMode = _repository.themeMode;

  final SettingsRepository _repository;

  bool _onboardingDone;
  String _userName;
  ThemeMode _themeMode;

  bool get onboardingDone => _onboardingDone;
  String get userName => _userName;
  bool get hasName => _userName.isNotEmpty;
  ThemeMode get themeMode => _themeMode;

  /// First letter of the name for the avatar, or an empty string.
  String get initial =>
      _userName.isEmpty ? '' : _userName.substring(0, 1).toUpperCase();

  Future<void> completeOnboarding() async {
    if (_onboardingDone) return;
    _onboardingDone = true;
    notifyListeners();
    await _repository.setOnboardingDone();
  }

  Future<void> setUserName(String value) async {
    final trimmed = value.trim();
    if (trimmed == _userName) return;
    _userName = trimmed;
    notifyListeners();
    await _repository.setUserName(trimmed);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
    await _repository.setThemeMode(mode);
  }

  /// Forgets the name and theme choice.
  Future<void> reset() async {
    _userName = '';
    _themeMode = ThemeMode.system;
    notifyListeners();
    await _repository.reset();
  }
}
