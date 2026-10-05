/// Turns durations into text for timers.
abstract final class DurationFormat {
  /// Countdown clock: `09:05` or `1:30:00`. Rounds up so it never shows
  /// 00:00 before the timer has really finished.
  static String clock(Duration duration) {
    final ms = duration.inMilliseconds < 0 ? 0 : duration.inMilliseconds;
    final total = (ms + 999) ~/ 1000;
    final hours = total ~/ 3600;
    final minutes = (total % 3600) ~/ 60;
    final seconds = total % 60;
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$mm:$ss' : '$mm:$ss';
  }

  /// Short words: `10 min`, `1 hr 30 min`, `45 sec`.
  static String words(Duration duration) {
    final total = duration.inSeconds;
    final hours = total ~/ 3600;
    final minutes = (total % 3600) ~/ 60;
    final seconds = total % 60;
    final parts = <String>[
      if (hours > 0) '$hours hr',
      if (minutes > 0) '$minutes min',
      if (seconds > 0 && hours == 0) '$seconds sec',
    ];
    return parts.isEmpty ? '0 sec' : parts.join(' ');
  }
}
