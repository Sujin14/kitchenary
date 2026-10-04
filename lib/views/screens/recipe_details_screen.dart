import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/recipe_details_controller.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/services/recipe_service.dart';
import 'package:kitchenary/views/widgets/details/recipe_details_body.dart';
import 'package:provider/provider.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeDetailsController>(
      create: (context) =>
          RecipeDetailsController(context.read<RecipeService>(), recipe),
      child: const Scaffold(body: RecipeDetailsBody()),
    );
  }
}
