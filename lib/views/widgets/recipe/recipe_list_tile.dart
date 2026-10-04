import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/widgets/common/app_card.dart';
import 'package:kitchenary/views/widgets/common/diet_mark.dart';
import 'package:kitchenary/views/widgets/common/recipe_image.dart';

/// A compact row: small photo, title and source. Opens the details screen.
class RecipeListTile extends StatelessWidget {
  const RecipeListTile({required this.recipe, this.trailing, super.key});

  final Recipe recipe;

  /// Optional widget at the end of the row (for example a menu).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      onTap: () => context.openRecipe(recipe),
      padding: EdgeInsets.all(10.r),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              width: 72.r,
              height: 72.r,
              child: RecipeImage(url: recipe.imageUrl, height: 72.r, width: 72.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleSmall,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    DietMark(diet: recipe.diet, size: 14.r),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        recipe.sourceLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: p.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
