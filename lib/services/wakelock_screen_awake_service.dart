import 'package:kitchenary/services/screen_awake_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// [ScreenAwakeService] backed by the `wakelock_plus` package.
final class WakelockScreenAwakeService implements ScreenAwakeService {
  const WakelockScreenAwakeService();

  @override
  Future<void> keepAwake() async {
    try {
      await WakelockPlus.enable();
    } on Object {
      // Not being able to keep the screen on must never stop cooking.
    }
  }

  @override
  Future<void> allowSleep() async {
    try {
      await WakelockPlus.disable();
    } on Object {
      // Ignore: see above.
    }
  }
}
