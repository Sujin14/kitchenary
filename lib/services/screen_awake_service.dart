/// Keeps the screen from turning off while the user is cooking.
abstract interface class ScreenAwakeService {
  Future<void> keepAwake();
  Future<void> allowSleep();
}
