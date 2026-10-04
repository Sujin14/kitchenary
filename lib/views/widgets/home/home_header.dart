import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
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
                const SizedBox(height: 2),
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
