import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/views/widgets/home/random_recipe_button.dart';

/// App name, tagline and the random-recipe button.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: p.primary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  AppConstants.tagline,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: p.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const RandomRecipeButton(),
        ],
      ),
    );
  }
}
