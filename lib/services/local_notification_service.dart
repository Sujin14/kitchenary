import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kitchenary/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

/// `NotificationService` backed by `flutter_local_notifications`.
///
/// Starts itself the first time a timer is set, so the notification
/// permission is asked at the moment it makes sense.
final class LocalNotificationService implements NotificationService {
  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  /// Android freezes a channel's sound once it exists, so changing the sound
  /// needs a new id (and deleting the old channel).
  static const String _channelId = 'kitchenary_timers_alarm_v2';
  static const List<String> _oldChannelIds = ['kitchenary_timers_alarm'];
  static const String _channelName = 'Cooking timers';
  static const String _channelDescription =
      'Rings when a cooking timer you started is done.';

  /// `android/app/src/main/res/raw/timer_alarm.wav`.
  static const AndroidNotificationSound _sound =
      RawResourceAndroidNotificationSound('timer_alarm');

  /// Android's FLAG_INSISTENT: keep sounding until the user reacts.
  static const int _insistentFlag = 4;

  static final NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      category: AndroidNotificationCategory.alarm,
      playSound: true,
      sound: _sound,
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      additionalFlags: Int32List.fromList([_insistentFlag]),
    ),
  );

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  Future<void> _prepare() async {
    if (_ready) return;
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    final android = _android;
    for (final oldId in _oldChannelIds) {
      await android?.deleteNotificationChannel(oldId);
    }
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
        playSound: true,
        sound: _sound,
        enableVibration: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
    );
    _ready = true;
  }

  Future<bool> _allowed() async {
    final android = _android;
    if (android == null) return false;
    if (await android.areNotificationsEnabled() ?? false) return true;
    return await android.requestNotificationsPermission() ?? false;
  }

  @override
  Future<bool> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
  }) async {
    try {
      await _prepare();
      if (!await _allowed()) return false;
      final when = tz.TZDateTime.from(at, tz.UTC);
      try {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          when,
          _details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } on PlatformException {
        // Exact alarms are not allowed for this app on newer Android:
        // fall back to a slightly less precise one.
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          when,
          _details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> cancel(int id) async {
    try {
      await _prepare();
      await _plugin.cancel(id);
    } catch (_) {
      // Nothing useful to do: the timer is already gone from the screen.
    }
  }
}
