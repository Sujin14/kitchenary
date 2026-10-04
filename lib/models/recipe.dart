import 'package:kitchenary/models/diet_type.dart';
import 'package:kitchenary/models/difficulty.dart';
import 'package:kitchenary/models/recipe_ingredient.dart';

/// A recipe from TheMealDB (or, later, written by the user).
///
/// List endpoints return only an id, name and picture; those recipes have
/// [isSummary] set to true and must be loaded in full before cooking.
class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.category = '',
    this.area = '',
    this.tags = const [],
    this.ingredients = const [],
    this.steps = const [],
    this.videoUrl = '',
    this.sourceUrl = '',
    this.isSummary = false,
    this.customDiet,
  });

  /// Id prefix of recipes the user wrote themselves.
  static const String ownPrefix = 'own_';

  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final String area;
  final List<String> tags;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final String videoUrl;
  final String sourceUrl;
  final bool isSummary;

  /// Set by the user for their own recipes; overrides the inferred diet.
  final DietType? customDiet;

  /// True for recipes written by the user (stored only on this device).
  bool get isOwn => id.startsWith(ownPrefix);

  bool get hasSteps => steps.isNotEmpty;
  bool get hasVideo => videoUrl.isNotEmpty;
  bool get hasSourceUrl => sourceUrl.isNotEmpty;

  /// "Indian cuisine", or "TheMealDB" when the cuisine is unknown.
  String get sourceLabel => isOwn
      ? 'My recipe'
      : area.isNotEmpty && area.toLowerCase() != 'unknown'
      ? '$area cuisine'
      : 'TheMealDB';

  static const Set<String> _nonVegCategories = {
    'chicken',
    'beef',
    'lamb',
    'goat',
    'pork',
    'seafood',
  };

  /// Inferred from the recipe category; recipes in other categories
  /// (Pasta, Dessert, Side...) are reported as [DietType.unknown].
  DietType get diet {
    final custom = customDiet;
    if (custom != null) return custom;
    final c = category.toLowerCase();
    if (c == 'vegan') return DietType.vegan;
    if (c == 'vegetarian') return DietType.vegetarian;
    if (_nonVegCategories.contains(c)) return DietType.nonVeg;
    return DietType.unknown;
  }

  /// Rough estimate from ingredient and step counts (the API has no times).
  /// Only meaningful for full recipes.
  Difficulty get difficulty {
    final n = ingredients.length;
    final s = steps.length;
    if (n <= 7 && s <= 5) return Difficulty.easy;
    if (n <= 12 && s <= 9) return Difficulty.medium;
    return Difficulty.hard;
  }

  /// Parses a meal from a list endpoint (`filter.php`): id, name, picture.
  factory Recipe.summaryFromMealDb(Map<String, dynamic> json) => Recipe(
        id: (json['idMeal'] as String? ?? '').trim(),
        title: (json['strMeal'] as String? ?? '').trim(),
        imageUrl: (json['strMealThumb'] as String? ?? '').trim(),
        isSummary: true,
      );

  /// Parses a full meal (`search.php`, `lookup.php`, `random.php`).
  factory Recipe.fromMealDb(Map<String, dynamic> json) {
    String text(String key) => (json[key] as String?)?.trim() ?? '';

    final ingredients = <RecipeIngredient>[];
    for (var i = 1; i <= 20; i++) {
      final name = text('strIngredient$i');
      if (name.isEmpty) continue;
      ingredients.add(
        RecipeIngredient(name: name, measure: text('strMeasure$i')),
      );
    }

    return Recipe(
      id: text('idMeal'),
      title: text('strMeal'),
      imageUrl: text('strMealThumb'),
      category: text('strCategory'),
      area: text('strArea'),
      tags: text('strTags')
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
      ingredients: ingredients,
      steps: splitInstructions(text('strInstructions')),
      videoUrl: text('strYoutube'),
      sourceUrl: text('strSource'),
    );
  }

  /// Turns the free-text method into short, readable steps.
  ///
  /// Handles `STEP 1` headings, `1.` / `2)` prefixes, and long single
  /// paragraphs (grouped sentence by sentence into chunks of about 220
  /// characters).
  static List<String> splitInstructions(String text) {
    if (text.trim().isEmpty) return const [];

    final heading = RegExp(
      r'^(?:step\s*\d+[:.)-]?|\d+[.)]?)$',
      caseSensitive: false,
    );
    final prefix = RegExp(
      r'^(?:step\s*\d+\s*[:.)-]\s*|\d+\s*[.)]\s*)',
      caseSensitive: false,
    );

    final lines = text
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty && !heading.hasMatch(l))
        .map((l) => l.replaceFirst(prefix, '').trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (lines.length > 1) return lines;

    final single = lines.isEmpty ? text.trim() : lines.single;
    if (single.length <= 220) return [single];

    final sentences = single.split(RegExp(r'(?<=[.!?])\s+'));
    final steps = <String>[];
    var current = '';
    for (final sentence in sentences) {
      if (current.isNotEmpty && current.length + sentence.length > 220) {
        steps.add(current);
        current = sentence;
      } else {
        current = current.isEmpty ? sentence : '$current $sentence';
      }
    }
    if (current.isNotEmpty) steps.add(current);
    return steps;
  }

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        category: json['category'] as String? ?? '',
        area: json['area'] as String? ?? '',
        tags: (json['tags'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(),
        ingredients: (json['ingredients'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(RecipeIngredient.fromJson)
            .toList(),
        steps: (json['steps'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(),
        videoUrl: json['videoUrl'] as String? ?? '',
        sourceUrl: json['sourceUrl'] as String? ?? '',
        isSummary: json['isSummary'] as bool? ?? false,
        customDiet: DietType.values.asNameMap()[json['customDiet'] as String?],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imageUrl': imageUrl,
        'category': category,
        'area': area,
        'tags': tags,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'steps': steps,
        'videoUrl': videoUrl,
        'sourceUrl': sourceUrl,
        'isSummary': isSummary,
        if (customDiet != null) 'customDiet': customDiet!.name,
      };
}
