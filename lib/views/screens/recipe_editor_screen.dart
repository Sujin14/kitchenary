import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/recipe_editor_controller.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/widgets/editor/recipe_editor_form.dart';
import 'package:provider/provider.dart';

/// Write a new recipe, or edit one of the user's own ([existing]).
class RecipeEditorScreen extends StatelessWidget {
  const RecipeEditorScreen({this.existing, super.key});

  final Recipe? existing;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeEditorController>(
      create: (_) => RecipeEditorController(existing: existing),
      child: Scaffold(
        appBar: AppBar(
          title: Text(existing == null ? 'New recipe' : 'Edit recipe'),
        ),
        body: const SafeArea(child: RecipeEditorForm()),
      ),
    );
  }
}
