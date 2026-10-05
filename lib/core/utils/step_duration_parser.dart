/// A time found inside a recipe step, e.g. "10 minutes".
class DetectedDuration {
  const DetectedDuration({required this.duration, required this.text});

  final Duration duration;

  /// The words it was read from, e.g. "1 hour 30 minutes".
  final String text;
}

/// Finds cooking times ("simmer for 10 minutes") in step text so cooking mode
/// can offer a one-tap timer. Pure Dart.
abstract final class StepDurationParser {
  static const int maxResults = 3;
  static const Duration maxDuration = Duration(hours: 24);

  static const Map<String, double> _words = {
    'a': 1,
    'an': 1,
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
    'ten': 10,
    'twelve': 12,
    'fifteen': 15,
    'twenty': 20,
    'thirty': 30,
    'forty': 40,
    'forty-five': 45,
    'fifty': 50,
    'sixty': 60,
  };

  static final RegExp _pattern = RegExp(
    r'\b(\d+(?:\.\d+)?(?:\s+\d+/\d+)?|\d+/\d+|half(?:\s+an?)?|'
    r'forty-five|twelve|fifteen|twenty|thirty|forty|fifty|sixty|'
    r'one|two|three|four|five|six|seven|eight|nine|ten|an?)'
    r'(?:\s*(?:-|–|to)\s*(\d+(?:\.\d+)?))?'
    r'\s*(hours?|hrs?|minutes?|mins?|seconds?|secs?)\b',
    caseSensitive: false,
  );

  static final RegExp _joiner = RegExp(r'^\s*(?:and|,)?\s*$', caseSensitive: false);

  static List<DetectedDuration> find(String text) {
    final parts = <_Part>[];
    for (final match in _pattern.allMatches(text)) {
      // For a range ("10-15 minutes") use the shorter time: better to check
      // early than to overcook.
      final value = _number(match.group(1)!);
      if (value == null) continue;
      final unit = match.group(3)!.toLowerCase();
      final seconds = (value * _secondsPerUnit(unit)).round();
      if (seconds <= 0) continue;

      final previous = parts.isEmpty ? null : parts.last;
      final canJoin = previous != null &&
          previous.isHours &&
          unit.startsWith('m') &&
          _joiner.hasMatch(text.substring(previous.end, match.start));
      if (previous != null && canJoin) {
        previous.seconds += seconds;
        previous.end = match.end;
        previous.isHours = false;
      } else {
        parts.add(_Part(
          start: match.start,
          end: match.end,
          seconds: seconds,
          isHours: unit.startsWith('h'),
        ));
      }
    }

    final found = <DetectedDuration>[];
    for (final part in parts) {
      final duration = Duration(seconds: part.seconds);
      if (duration > maxDuration) continue;
      if (found.any((d) => d.duration == duration)) continue;
      found.add(DetectedDuration(
        duration: duration,
        text: text.substring(part.start, part.end),
      ));
      if (found.length == maxResults) break;
    }
    return found;
  }

  static int _secondsPerUnit(String unit) {
    if (unit.startsWith('h')) return 3600;
    if (unit.startsWith('m')) return 60;
    return 1;
  }

  static double? _number(String raw) {
    final word = raw.trim().toLowerCase();
    if (word.startsWith('half')) return 0.5;
    if (_words.containsKey(word)) return _words[word];
    var total = 0.0;
    for (final piece in raw.trim().split(RegExp(r'\s+'))) {
      if (piece.contains('/')) {
        final fraction = piece.split('/');
        final top = double.tryParse(fraction[0]);
        final bottom = double.tryParse(fraction[1]);
        if (top == null || bottom == null || bottom == 0) return null;
        total += top / bottom;
      } else {
        final value = double.tryParse(piece);
        if (value == null) return null;
        total += value;
      }
    }
    return total;
  }
}

class _Part {
  _Part({
    required this.start,
    required this.end,
    required this.seconds,
    required this.isHours,
  });

  final int start;
  int end;
  int seconds;
  bool isHours;
}
