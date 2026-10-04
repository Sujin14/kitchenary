/// One ingredient line: a name and an optional measure ("1 1/2 cup").
class RecipeIngredient {
  const RecipeIngredient({required this.name, this.measure = ''});

  final String name;
  final String measure;

  /// Text shown in lists, e.g. "200g Chicken".
  String get displayText => measure.isEmpty ? name : '$measure $name';

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      RecipeIngredient(
        name: json['name'] as String? ?? '',
        measure: json['measure'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'name': name, 'measure': measure};
}
