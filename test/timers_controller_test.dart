import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/timers_controller.dart';
import 'package:kitchenary/models/cooking_timer.dart';

import 'helpers/fake_alarm_sound_service.dart';
import 'helpers/fake_notification_service.dart';

void main() {
  late DateTime now;
  late bool foreground;
  late FakeNotificationService notifications;
  late FakeAlarmSoundService alarm;
  late TimersController timers;

  setUp(() {
    now = DateTime(2026, 10, 4, 12);
    foreground = true;
    notifications = FakeNotificationService();
    alarm = FakeAlarmSoundService();
    timers = TimersController(
      notifications,
      alarm,
      now: () => now,
      isInForeground: () => foreground,
      autoTick: false,
    );
  });

  tearDown(() => timers.dispose());

  Future<void> startTen() => timers.start(
        recipeTitle: 'Dal',
        label: 'Step 2',
        duration: const Duration(minutes: 10),
      );

  test('start adds a running timer and schedules a notification', () async {
    await startTen();

    expect(timers.timers, hasLength(1));
    final timer = timers.timers.single;
    expect(timer.isRunning, isTrue);
    expect(timers.remaining(timer), const Duration(minutes: 10));
    expect(notifications.scheduled[timer.id]!.at, now.add(const Duration(minutes: 10)));
    expect(notifications.scheduled[timer.id]!.body, contains('Dal'));
  });

  test('time passing reduces the remaining time', () async {
    await startTen();
    now = now.add(const Duration(minutes: 4));
    timers.tick();
    expect(timers.remaining(timers.timers.single), const Duration(minutes: 6));
    expect(timers.timers.single.isRunning, isTrue);
  });

  test('finishes when time is up', () async {
    await startTen();
    now = now.add(const Duration(minutes: 11));
    timers.tick();
    expect(timers.timers.single.phase, TimerPhase.finished);
    expect(timers.remaining(timers.timers.single), Duration.zero);
    expect(timers.hasRunning, isFalse);
  });

  test('pause keeps the time left and cancels the alert', () async {
    await startTen();
    final id = timers.timers.single.id;
    now = now.add(const Duration(minutes: 3));
    await timers.pause(id);

    expect(timers.timers.single.isPaused, isTrue);
    expect(notifications.scheduled, isEmpty);
    now = now.add(const Duration(minutes: 30));
    expect(timers.remaining(timers.timers.single), const Duration(minutes: 7));
  });

  test('resume reschedules from the time left', () async {
    await startTen();
    final id = timers.timers.single.id;
    now = now.add(const Duration(minutes: 3));
    await timers.pause(id);
    now = now.add(const Duration(minutes: 5));
    await timers.resume(id);

    expect(timers.timers.single.isRunning, isTrue);
    expect(notifications.scheduled[id]!.at, now.add(const Duration(minutes: 7)));
  });

  test('remove deletes the timer and its notification', () async {
    await startTen();
    final id = timers.timers.single.id;
    await timers.remove(id);
    expect(timers.timers, isEmpty);
    expect(notifications.cancelled, contains(id));
  });

  test('several timers run independently', () async {
    await startTen();
    await timers.start(
      recipeTitle: 'Dal',
      label: 'Step 4',
      duration: const Duration(minutes: 2),
    );
    now = now.add(const Duration(minutes: 3));
    timers.tick();
    expect(timers.timers[0].isRunning, isTrue);
    expect(timers.timers[1].isFinished, isTrue);
    expect(timers.timers[0].id, isNot(timers.timers[1].id));
  });

  test('flags blocked alerts when notifications are off', () async {
    notifications.allowed = false;
    await startTen();
    expect(timers.alertsBlocked, isTrue);
    expect(timers.timers, hasLength(1));
  });

  group('ringing in the app', () {
    test('rings when a timer runs out while the app is open, '
        'and cancels its notification so sounds do not overlap', () async {
      await startTen();
      final id = timers.timers.single.id;
      now = now.add(const Duration(minutes: 10, seconds: 1));
      timers.tick();

      expect(alarm.isPlaying, isTrue);
      expect(notifications.cancelled, contains(id));
    });

    test('dismissing the finished timer stops the sound', () async {
      await startTen();
      final id = timers.timers.single.id;
      now = now.add(const Duration(minutes: 10));
      timers.tick();
      await timers.remove(id);

      expect(alarm.isPlaying, isFalse);
      expect(alarm.stopCalls, 1);
    });

    test('keeps ringing until the last finished timer is dismissed', () async {
      await startTen();
      await timers.start(
        recipeTitle: 'Dal',
        label: 'Step 4',
        duration: const Duration(minutes: 10),
      );
      final [first, second] = timers.timers;
      now = now.add(const Duration(minutes: 10));
      timers.tick();
      expect(alarm.playCalls, 1);

      await timers.remove(first.id);
      expect(alarm.isPlaying, isTrue);
      await timers.remove(second.id);
      expect(alarm.isPlaying, isFalse);
    });

    test('stays quiet in the background; the notification rings', () async {
      await startTen();
      final id = timers.timers.single.id;
      foreground = false;
      now = now.add(const Duration(minutes: 10));
      timers.tick();

      expect(timers.timers.single.isFinished, isTrue);
      expect(alarm.playCalls, 0);
      expect(notifications.scheduled, contains(id));
    });

    test('does not ring for a timer that ran out long before the app was '
        'reopened', () async {
      await startTen();
      now = now.add(
        const Duration(minutes: 10) +
            TimersController.inAppRingWindow +
            const Duration(seconds: 1),
      );
      timers.tick();

      expect(timers.timers.single.isFinished, isTrue);
      expect(alarm.playCalls, 0);
    });

    test('removing a running timer does not touch the sound', () async {
      await startTen();
      await timers.remove(timers.timers.single.id);
      expect(alarm.playCalls, 0);
      expect(alarm.stopCalls, 0);
    });

    test('dispose stops a ringing alarm', () async {
      final own = TimersController(
        FakeNotificationService(),
        alarm,
        now: () => now,
        isInForeground: () => true,
        autoTick: false,
      );
      await own.start(
        recipeTitle: 'Dal',
        label: 'Step 1',
        duration: const Duration(minutes: 1),
      );
      now = now.add(const Duration(minutes: 1));
      own.tick();
      expect(alarm.isPlaying, isTrue);

      own.dispose();
      expect(alarm.isPlaying, isFalse);
    });
  });
}
