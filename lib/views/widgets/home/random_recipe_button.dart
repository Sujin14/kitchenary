import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/home_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/navigation/app_routes.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:provider/provider.dart';

/// "Surprise me": opens a random recipe.
class RandomRecipeButton extends StatelessWidget {
  const RandomRecipeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final loading =
        context.select<HomeController, bool>((home) => home.loadingRandom);
    final p = context.palette;

    return IconButton.filled(
      tooltip: 'Surprise me with a random recipe',
      style: IconButton.styleFrom(
        backgroundColor: p.accent,
        foregroundColor: p.onAccent,
        minimumSize: const Size(48, 48),
      ),
      icon: loading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: p.onAccent,
              ),
            )
          : const Icon(Icons.casino_outlined),
      onPressed: loading
          ? null
          : () async {
              final recipe = await context.read<HomeController>().pickRandom();
              if (!context.mounted) return;
              if (recipe == null) {
                AppSnackBar.show(context, 'Could not fetch a recipe. Try again.');
                return;
              }
              await context.pushNamed<void>(
                AppRoutes.recipeDetails,
                arguments: recipe,
              );
            },
    );
  }
}
