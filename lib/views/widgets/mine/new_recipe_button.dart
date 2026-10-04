import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';

/// Round "+" button that opens an empty recipe form.
class NewRecipeButton extends StatelessWidget {
  const NewRecipeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return IconButton.filled(
      tooltip: 'Write a new recipe',
      style: IconButton.styleFrom(
        backgroundColor: p.primary,
        foregroundColor: p.onPrimary,
        minimumSize: Size(48.r, 48.r),
      ),
      icon: const Icon(Icons.add),
      onPressed: () => context.openRecipeEditor(),
    );
  }
}
