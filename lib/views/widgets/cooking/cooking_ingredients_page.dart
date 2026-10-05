import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/cooking_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/theme/app_text_styles.dart';
import 'package:kitchenary/views/widgets/cooking/cooking_ingredient_tile.dart';
import 'package:provider/provider.dart';

/// First page of cooking mode: gather and tick off the ingredients.
class CookingIngredientsPage extends StatelessWidget {
  const CookingIngredientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cooking = context.watch<CookingController>();
    final p = context.palette;
    final texts = cooking.ingredientTexts;
    return ListView(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
      children: [
        Text(
          'Get everything ready',
          style: context.textTheme.headlineMedium?.copyWith(
            color: p.cookingText,
            fontSize: AppTextStyles.cookingHeadingSize,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'For ${cooking.servings} ${cooking.servings == 1 ? 'person' : 'people'}'
          '. Tap an ingredient to tick it off.',
          style: context.textTheme.bodyLarge?.copyWith(
            color: p.cookingText.withValues(alpha: 0.75),
          ),
        ),
        SizedBox(height: 16.h),
        for (var i = 0; i < texts.length; i++)
          CookingIngredientTile(
            text: texts[i],
            checked: cooking.isChecked(i),
            onTap: () => cooking.toggleIngredient(i),
          ),
      ],
    );
  }
}
