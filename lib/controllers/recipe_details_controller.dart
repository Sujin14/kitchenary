import 'package:flutter/foundation.dart';
import 'package:kitchenary/controllers/load_status.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/services/api_exception.dart';
import 'package:kitchenary/services/recipe_service.dart';

/// Loads the full recipe behind a summary card.
class RecipeDetailsController extends ChangeNotifier {
  RecipeDetailsController(this._service, Recipe initial) : _recipe = initial {
    if (initial.isSummary) {
      load();
    } else {
      _status = LoadStatus.success;
    }
  }

  final RecipeService _service;
  Recipe _recipe;
  LoadStatus _status = LoadStatus.loading;
  String _errorMessage = '';
  bool _disposed = false;

  Recipe get recipe => _recipe;
  LoadStatus get status => _status;
  String get errorMessage => _errorMessage;

  Future<void> load() async {
    _status = LoadStatus.loading;
    _notify();
    try {
      final full = await _service.lookup(_recipe.id);
      if (full == null) {
        _errorMessage = 'This recipe is no longer available.';
        _status = LoadStatus.error;
      } else {
        _recipe = full;
        _status = LoadStatus.success;
      }
    } on ApiException catch (error) {
      _errorMessage = error.message;
      _status = LoadStatus.error;
    } catch (_) {
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
    super.dispose();
  }
}
