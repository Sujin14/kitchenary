import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/saved_recipes_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:kitchenary/views/widgets/common/circle_icon_button.dart';
import 'package:provider/provider.dart';

/// Heart button that saves or un-saves a recipe. Hidden for the user's own
/// recipes, which already live under "My recipes".
///
/// [compact] is the small version used on grid cards.
class SaveRecipeButton extends StatelessWidget {
  const SaveRecipeButton({
    required this.recipe,
    this.compact = false,
    super.key,
  });

  final Recipe recipe;
  final bool compact;

  Future<void> _toggle(BuildContext context) async {
    final nowSaved = await context.read<SavedRecipesController>().toggle(recipe);
    if (!context.mounted) return;
    AppSnackBar.show(
      context,
      nowSaved ? 'Saved to your recipes' : 'Removed from saved',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (recipe.isOwn) return const SizedBox.shrink();

    final saved = context.select<SavedRecipesController, bool>(
      (saved) => saved.isSaved(recipe.id),
    );
    final p = context.palette;
    final icon = saved ? Icons.favorite : Icons.favorite_border;
    final color = saved ? p.accent : p.textPrimary;
    final tooltip = saved ? 'Remove from saved' : 'Save recipe';

    if (!compact) {
      return CircleIconButton(
        icon: icon,
        iconColor: color,
        tooltip: tooltip,
        onPressed: () => _toggle(context),
      );
    }

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _toggle(context),
        child: Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: p.overlayControl,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18.sp, color: color),
        ),
      ),
    );
  }
}
