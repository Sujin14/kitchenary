/// Scales the amount at the start of a recipe measure, e.g.
/// `1 1/2 cup` x 2 = `3 cup`, `200g` x 2.5 = `500g`.
///
/// Measures that do not start with a number ("to taste", "Juice of 1") are
/// returned unchanged. Pure Dart, no Flutter.
abstract final class QuantityScaler {
  static const String _numberSource =
      r'\d+\s+\d+/\d+|\d+/\d+|\d*\.\d+|\d+';

  /// A number, optionally followed by a range end ("2-3", "2 to 3").
  static final RegExp _leading = RegExp(
    '^($_numberSource)(?:\\s*(?:-|–|to)\\s*($_numberSource))?',
  );

  /// "g/14oz": a second, alternative unit that must not be scaled separately.
  static final RegExp _alternativeUnit = RegExp(r'^(\s*[A-Za-z]+\.?)\s*/\s*\d.*$');

  static const Map<String, String> _unicodeFractions = {
    '½': ' 1/2',
    '¼': ' 1/4',
    '¾': ' 3/4',
    '⅓': ' 1/3',
    '⅔': ' 2/3',
    '⅛': ' 1/8',
    '⅜': ' 3/8',
    '⅝': ' 5/8',
    '⅞': ' 7/8',
  };

  static const Set<String> _metricUnits = {
    'g',
    'gm',
    'gram',
    'grams',
    'ml',
    'millilitre',
    'millilitres',
    'milliliter',
    'milliliters',
  };

  static const List<double> _fractionValues = [
    0,
    0.125,
    0.25,
    1 / 3,
    0.375,
    0.5,
    0.625,
    2 / 3,
    0.75,
    0.875,
    1,
  ];

  static const List<String> _fractionLabels = [
    '',
    '1/8',
    '1/4',
    '1/3',
    '3/8',
    '1/2',
    '5/8',
    '2/3',
    '3/4',
    '7/8',
    '',
  ];

  /// Returns [measure] with its leading amount multiplied by [factor].
  static String scale(String measure, double factor) {
    final original = measure.trim();
    if (original.isEmpty || factor == 1 || factor <= 0) return original;

    final text = _normalize(original);
    final match = _leading.firstMatch(text);
    if (match == null) return original;

    final first = _parse(match.group(1)!);
    if (first == null || first <= 0) return original;
    final secondText = match.group(2);
    final second = secondText == null ? null : _parse(secondText);

    final rest = text
        .substring(match.end)
        .replaceFirstMapped(_alternativeUnit, (m) => m.group(1)!);
    final unit = _firstWord(rest);

    var a = first * factor;
    var b = second == null ? null : second * factor;
    var tail = rest;

    if (_metricUnits.contains(unit)) {
      final bare = rest.trim().toLowerCase();
      final biggest = b ?? a;
      if (biggest >= 1000 && (bare == 'g' || bare == 'ml')) {
        a /= 1000;
        if (b != null) b /= 1000;
        tail = rest.replaceFirst(RegExp('g|ml', caseSensitive: false), bare == 'g' ? 'kg' : 'l');
        return _join(_decimal(a), b == null ? null : _decimal(b), tail);
      }
      return _join(_metric(a), b == null ? null : _metric(b), tail);
    }
    return _join(_fraction(a), b == null ? null : _fraction(b), tail);
  }

  static String _join(String a, String? b, String tail) =>
      '$a${b == null ? '' : '-$b'}$tail';

  static String _normalize(String text) {
    var result = text;
    _unicodeFractions.forEach((symbol, ascii) {
      result = result.replaceAll(symbol, ascii);
    });
    return result.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String _firstWord(String text) {
    final trimmed = text.trim().toLowerCase();
    final end = trimmed.indexOf(RegExp(r'[\s,(/]'));
    return end == -1 ? trimmed : trimmed.substring(0, end);
  }

  static double? _parse(String text) {
    final s = text.trim();
    final mixed = RegExp(r'^(\d+)\s+(\d+)/(\d+)$').firstMatch(s);
    if (mixed != null) {
      final denominator = int.parse(mixed.group(3)!);
      if (denominator == 0) return null;
      return int.parse(mixed.group(1)!) +
          int.parse(mixed.group(2)!) / denominator;
    }
    final fraction = RegExp(r'^(\d+)/(\d+)$').firstMatch(s);
    if (fraction != null) {
      final denominator = int.parse(fraction.group(2)!);
      if (denominator == 0) return null;
      return int.parse(fraction.group(1)!) / denominator;
    }
    return double.tryParse(s);
  }

  /// Grams and millilitres: whole numbers (nearest 5 above 100).
  static String _metric(double value) {
    if (value >= 100) return ((value / 5).round() * 5).toString();
    if (value >= 10) return value.round().toString();
    return _decimal(value, places: 1);
  }

  static String _decimal(double value, {int places = 2}) {
    final text = value.toStringAsFixed(places);
    if (!text.contains('.')) return text;
    return text.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  /// Cups, spoons and counts: whole numbers and kitchen fractions.
  static String _fraction(double value) {
    if (value >= 20) return value.round().toString();
    var whole = value.floor();
    final fraction = value - whole;

    var best = 0;
    for (var i = 1; i < _fractionValues.length; i++) {
      if ((fraction - _fractionValues[i]).abs() <
          (fraction - _fractionValues[best]).abs()) {
        best = i;
      }
    }
    if (best == _fractionValues.length - 1) {
      whole += 1;
      best = 0;
    }
    if (whole == 0 && best == 0) return _fractionLabels[1]; // never "0"

    final parts = <String>[
      if (whole > 0) '$whole',
      if (_fractionLabels[best].isNotEmpty) _fractionLabels[best],
    ];
    return parts.join(' ');
  }
}
