import 'dart:async';

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
  HomeController(this._service) {
    selectCategory(RecipeCategory.indian);
  }

  final RecipeService _service;

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
    if (_query.isEmpty && _category != null) return;
    _query = '';
    selectCategory(_category ?? RecipeCategory.indian);
  }

  /// Selects [category]. Tapping the selected chip again keeps it selected
  /// but clears any sub-chip.
  void selectCategory(RecipeCategory category) {
    _query = '';
    _category = category;
    _subcategory = null;
    _load();
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
      } else {
        final category = _category ?? RecipeCategory.indian;
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
