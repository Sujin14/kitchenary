import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';

/// A selectable pill used for categories and sub-categories.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.compact = false,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: (compact ? 14 : 18).w,
            vertical: (compact ? 8 : 11).h,
          ),
          decoration: BoxDecoration(
            color: selected ? p.primary : p.surface,
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: selected ? p.primary : p.outline),
          ),
          child: Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              color: selected ? p.onPrimary : p.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
