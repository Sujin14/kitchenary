enum TimerPhase { running, paused, finished }

/// One countdown started from cooking mode. Immutable; the controller
/// replaces it as it changes.
class CookingTimer {
  const CookingTimer({
    required this.id,
    required this.recipeTitle,
    required this.label,
    required this.total,
    required this.phase,
    required this.remaining,
    this.endAt,
  });

  /// Also used as the notification id.
  final int id;
  final String recipeTitle;

  /// Short name such as "Step 3" or "10 min timer".
  final String label;
  final Duration total;
  final TimerPhase phase;

  /// Time left when paused (zero when finished). Ignored while running.
  final Duration remaining;

  /// Wall-clock moment the timer rings. Only set while running.
  final DateTime? endAt;

  bool get isRunning => phase == TimerPhase.running;
  bool get isPaused => phase == TimerPhase.paused;
  bool get isFinished => phase == TimerPhase.finished;

  /// Time left at [now].
  Duration remainingAt(DateTime now) {
    if (!isRunning || endAt == null) return remaining;
    final left = endAt!.difference(now);
    return left.isNegative ? Duration.zero : left;
  }

  CookingTimer copyWith({
    TimerPhase? phase,
    Duration? remaining,
    DateTime? endAt,
    bool clearEndAt = false,
  }) {
    return CookingTimer(
      id: id,
      recipeTitle: recipeTitle,
      label: label,
      total: total,
      phase: phase ?? this.phase,
      remaining: remaining ?? this.remaining,
      endAt: clearEndAt ? null : (endAt ?? this.endAt),
    );
  }
}
