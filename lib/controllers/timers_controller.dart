import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:kitchenary/models/cooking_timer.dart';
import 'package:kitchenary/services/alarm_sound_service.dart';
import 'package:kitchenary/services/notification_service.dart';

/// Cooking timers. Several can run at once and they keep running when you
/// leave cooking mode. Time is measured against the clock, so a timer stays
/// right while the app is in the background.
///
/// A timer that runs out while the app is open rings inside the app until its
/// chip is dismissed; otherwise its scheduled notification does the ringing.
class TimersController extends ChangeNotifier {
  TimersController(
    this._notifications,
    this._alarmSound, {
    DateTime Function()? now,
    bool Function()? isInForeground,
    Duration tickEvery = const Duration(seconds: 1),
    bool autoTick = true,
  })  : _now = now ?? DateTime.now,
        _isInForeground = isInForeground ?? _appIsResumed,
        _tickEvery = tickEvery,
        _autoTick = autoTick;

  /// A timer that ran out longer ago than this (the app was in the background
  /// or the phone was asleep) has already rung through its notification.
  static const Duration inAppRingWindow = Duration(seconds: 30);

  final NotificationService _notifications;
  final AlarmSoundService _alarmSound;
  final DateTime Function() _now;
  final bool Function() _isInForeground;
  final Duration _tickEvery;
  final bool _autoTick;

  final List<CookingTimer> _timers = [];
  final Set<int> _ringing = {};
  Timer? _ticker;
  int _nextId = 1;
  bool _alertsBlocked = false;

  static bool _appIsResumed() =>
      SchedulerBinding.instance.lifecycleState == AppLifecycleState.resumed;

  List<CookingTimer> get timers => List.unmodifiable(_timers);
  bool get hasTimers => _timers.isNotEmpty;
  bool get hasRunning => _timers.any((t) => t.isRunning);

  /// True when a notification could not be scheduled, so the user will not
  /// be alerted while the app is closed.
  bool get alertsBlocked => _alertsBlocked;

  Duration remaining(CookingTimer timer) => timer.remainingAt(_now());

  Future<void> start({
    required String recipeTitle,
    required String label,
    required Duration duration,
  }) async {
    final timer = CookingTimer(
      id: _nextId++,
      recipeTitle: recipeTitle,
      label: label,
      total: duration,
      phase: TimerPhase.running,
      remaining: duration,
      endAt: _now().add(duration),
    );
    _timers.add(timer);
    _ensureTicker();
    notifyListeners();
    await _schedule(timer);
  }

  Future<void> pause(int id) async {
    final index = _indexOf(id);
    if (index < 0 || !_timers[index].isRunning) return;
    final timer = _timers[index];
    _timers[index] = timer.copyWith(
      phase: TimerPhase.paused,
      remaining: timer.remainingAt(_now()),
      clearEndAt: true,
    );
    notifyListeners();
    await _notifications.cancel(id);
  }

  Future<void> resume(int id) async {
    final index = _indexOf(id);
    if (index < 0 || !_timers[index].isPaused) return;
    final timer = _timers[index];
    final resumed = timer.copyWith(
      phase: TimerPhase.running,
      endAt: _now().add(timer.remaining),
    );
    _timers[index] = resumed;
    _ensureTicker();
    notifyListeners();
    await _schedule(resumed);
  }

  /// Stops and removes a timer (also used to dismiss a finished one).
  Future<void> remove(int id) async {
    final index = _indexOf(id);
    if (index < 0) return;
    _timers.removeAt(index);
    if (!hasRunning) _stopTicker();
    notifyListeners();
    if (_ringing.remove(id) && _ringing.isEmpty) await _alarmSound.stop();
    await _notifications.cancel(id);
  }

  /// Marks timers that ran out as finished. Called every second while any
  /// timer is running; public so tests can drive it.
  void tick() {
    var changed = false;
    final now = _now();
    for (var i = 0; i < _timers.length; i++) {
      final timer = _timers[i];
      if (!timer.isRunning) continue;
      changed = true;
      if (timer.remainingAt(now) == Duration.zero) {
        _timers[i] = timer.copyWith(
          phase: TimerPhase.finished,
          remaining: Duration.zero,
          clearEndAt: true,
        );
        _ringInApp(timer, now);
      }
    }
    if (!hasRunning) _stopTicker();
    if (changed) notifyListeners();
  }

  Future<void> _schedule(CookingTimer timer) async {
    final scheduled = await _notifications.schedule(
      id: timer.id,
      title: 'Timer done',
      body: '${timer.recipeTitle} · ${timer.label} is ready',
      at: timer.endAt!,
    );
    if (!scheduled && !_alertsBlocked) {
      _alertsBlocked = true;
      notifyListeners();
    }
  }

  /// Rings for [timer], which just ran out, if the user is in the app. Its
  /// notification is cancelled so two looping sounds never play together.
  void _ringInApp(CookingTimer timer, DateTime now) {
    final endAt = timer.endAt;
    if (endAt == null || now.difference(endAt) > inAppRingWindow) return;
    if (!_isInForeground()) return;
    if (_ringing.isEmpty) unawaited(_alarmSound.play());
    _ringing.add(timer.id);
    unawaited(_notifications.cancel(timer.id));
  }

  int _indexOf(int id) => _timers.indexWhere((t) => t.id == id);

  void _ensureTicker() {
    if (!_autoTick || _ticker != null || !hasRunning) return;
    _ticker = Timer.periodic(_tickEvery, (_) => tick());
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    if (_ringing.isNotEmpty) unawaited(_alarmSound.stop());
    super.dispose();
  }
}
