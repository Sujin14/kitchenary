import 'package:kitchenary/core/utils/quantity_scaler.dart';

/// One ingredient line: a name and an optional measure ("1 1/2 cup").
class RecipeIngredient {
  const RecipeIngredient({required this.name, this.measure = ''});

  final String name;
  final String measure;

  /// Text shown in lists, e.g. "200g Chicken".
  String get displayText => measure.isEmpty ? name : '$measure $name';

  /// The measure multiplied by [factor] ("1 1/2 cup" x 2 = "3 cup").
  String scaledMeasure(double factor) =>
      QuantityScaler.scale(measure, factor);

  /// [displayText] with the measure scaled by [factor].
  String scaledText(double factor) {
    final scaled = scaledMeasure(factor);
    return scaled.isEmpty ? name : '$scaled $name';
  }

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      RecipeIngredient(
        name: json['name'] as String? ?? '',
        measure: json['measure'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'name': name, 'measure': measure};
}
