import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:kitchenary/controllers/load_status.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/models/recipe_category.dart';
import 'package:kitchenary/models/recipe_filter.dart';
import 'package:kitchenary/services/api_exception.dart';
import 'package:kitchenary/services/recipe_service.dart';

/// Drives the Home feed: search text, category chips and results.
class HomeController extends ChangeNotifier {
  HomeController(this._service, {Random? random})
      : _random = random ?? Random() {
    showMix();
  }

  /// How many random categories fill the mixed feed.
  static const int mixSize = 6;

  final RecipeService _service;
  final Random _random;

  Timer? _debounce;
  int _requestId = 0;
  bool _disposed = false;

  LoadStatus _status = LoadStatus.idle;
  List<Recipe> _recipes = const [];
  String _errorMessage = '';
  RecipeCategory? _category;
  RecipeFilter? _subcategory;
  String _query = '';
  bool _loadingRandom = false;

  LoadStatus get status => _status;
  List<Recipe> get recipes => _recipes;
  String get errorMessage => _errorMessage;
  RecipeCategory? get selectedCategory => _category;
  RecipeFilter? get selectedSubcategory => _subcategory;
  String get query => _query;
  bool get isSearching => _query.isNotEmpty;

  /// True while no search, pill or filter is chosen: the feed is a random
  /// mix of foods.
  bool get isMixed => _query.isEmpty && _category == null;
  bool get loadingRandom => _loadingRandom;
  List<RecipeCategory> get categories => RecipeCategory.all;

  /// Called on every keystroke; waits for a pause before hitting the API.
  void onSearchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounce, () => search(text));
  }

  void search(String text) {
    _debounce?.cancel();
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      clearSearch();
      return;
    }
    _query = trimmed;
    _category = null;
    _subcategory = null;
    _load();
  }

  void clearSearch() {
    _debounce?.cancel();
    if (_query.isEmpty) return;
    showMix();
  }

  /// Shows a fresh random mix of foods (the default feed).
  void showMix() {
    _debounce?.cancel();
    _query = '';
    _category = null;
    _subcategory = null;
    _load();
  }

  /// Selects [category]. Tapping the selected chip again keeps it selected
  /// but clears any sub-chip.
  void selectCategory(RecipeCategory category) {
    _query = '';
    _category = category;
    _subcategory = null;
    _load();
  }

  /// Sets the category and, optionally, one of its sub-filters in one go
  /// (used by the filter sheet).
  void applyFilter(RecipeCategory category, [RecipeFilter? sub]) {
    _query = '';
    _category = category;
    _subcategory = sub;
    _load();
  }

  /// Tap on the Veg / Non-veg pill. Selects it; a second tap clears a
  /// sub-filter, and a third goes back to the default feed.
  void toggleDiet(RecipeCategory category) {
    if (_category != category) {
      applyFilter(category);
    } else if (_subcategory != null) {
      applyFilter(category);
    } else {
      clearFilters();
    }
  }

  /// Back to the default feed: a random mix.
  void clearFilters() => showMix();

  /// True when something chosen in the filter sheet is narrowing the feed
  /// (anything other than the random mix or a plain Veg / Non-veg pill).
  bool get hasActiveFilter {
    final category = _category;
    if (category == null) return false;
    if (_subcategory != null) return true;
    return !RecipeCategory.diets.contains(category);
  }

  /// Selects a sub-chip; tapping it again returns to the whole category.
  void selectSubcategory(RecipeFilter filter) {
    if (_category == null) return;
    _subcategory = _subcategory == filter ? null : filter;
    _load();
  }

  Future<void> retry() => _load();

  /// A random full recipe, or null if the request failed.
  Future<Recipe?> pickRandom() async {
    if (_loadingRandom) return null;
    _loadingRandom = true;
    _notify();
    try {
      return await _service.random();
    } on ApiException {
      return null;
    } finally {
      _loadingRandom = false;
      _notify();
    }
  }

  Future<void> _load() async {
    final requestId = ++_requestId;
    _status = LoadStatus.loading;
    _notify();

    try {
      final List<Recipe> results;
      if (_query.isNotEmpty) {
        results = await _service.search(_query);
      } else if (_category == null) {
        final pool = [...RecipeCategory.mixPool]..shuffle(_random);
        final found = await _service.browse(pool.take(mixSize).toList());
        results = [...found]..shuffle(_random);
      } else {
        final category = _category!;
        final sub = _subcategory;
        results = await _service.browse(sub == null ? category.filters : [sub]);
      }
      if (requestId != _requestId) return; // superseded by a newer request
      _recipes = results;
      _errorMessage = '';
      _status = LoadStatus.success;
    } on ApiException catch (error) {
      if (requestId != _requestId) return;
      _errorMessage = error.message;
      _status = LoadStatus.error;
    } catch (_) {
      if (requestId != _requestId) return;
      _errorMessage = 'Something went wrong. Please try again.';
      _status = LoadStatus.error;
    }
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    super.dispose();
  }
}
