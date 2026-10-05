import 'package:flutter/services.dart';
import 'package:kitchenary/services/alarm_sound_service.dart';

/// [AlarmSoundService] that plays `res/raw/timer_alarm.wav` on the alarm
/// stream through `AlarmSoundPlayer` in the Android app (see `MainActivity`).
final class PlatformAlarmSoundService implements AlarmSoundService {
  const PlatformAlarmSoundService({
    MethodChannel channel = const MethodChannel(channelName),
  }) : _channel = channel;

  static const String channelName = 'app.kitchenary/alarm_sound';

  final MethodChannel _channel;

  @override
  Future<void> play() async {
    try {
      await _channel.invokeMethod<void>('play');
    } on Object {
      // A missing sound must never break the timers; the chip still shows.
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _channel.invokeMethod<void>('stop');
    } on Object {
      // Ignore: see above.
    }
  }
}
