import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/theme/app_text_styles.dart';

/// One ingredient to gather: tap to tick it off.
class CookingIngredientTile extends StatelessWidget {
  const CookingIngredientTile({
    required this.text,
    required this.checked,
    required this.onTap,
    super.key,
  });

  final String text;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = checked ? p.cookingText.withValues(alpha: 0.55) : p.cookingText;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        child: Row(
          children: [
            Icon(
              checked ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 30.sp,
              color: checked ? p.cookingAccent : p.cookingText,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: AppTextStyles.bodyFamily,
                  fontSize: AppTextStyles.cookingIngredientSize,
                  height: 1.3,
                  color: color,
                  decoration: checked ? TextDecoration.lineThrough : null,
                  decorationColor: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
