import 'package:kitchenary/services/alarm_sound_service.dart';

/// Records whether the in-app alarm would be ringing.
class FakeAlarmSoundService implements AlarmSoundService {
  bool isPlaying = false;
  int playCalls = 0;
  int stopCalls = 0;

  @override
  Future<void> play() async {
    playCalls++;
    isPlaying = true;
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    isPlaying = false;
  }
}
