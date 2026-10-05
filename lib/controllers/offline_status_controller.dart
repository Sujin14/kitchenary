import 'package:flutter/foundation.dart';

/// Whether the recipes on screen came from the phone's copy because the
/// recipe service could not be reached.
class OfflineStatusController extends ChangeNotifier {
  bool _offline = false;

  bool get isOffline => _offline;

  void markOffline() => _set(true);

  void markOnline() => _set(false);

  void _set(bool value) {
    if (_offline == value) return;
    _offline = value;
    notifyListeners();
  }
}
