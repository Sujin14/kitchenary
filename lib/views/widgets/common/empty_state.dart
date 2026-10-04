import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';

/// Friendly placeholder for lists with nothing to show.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;

  /// Optional button shown under the message.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final action = this.action;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56.sp, color: p.textHint),
            SizedBox(height: 16.h),
            Text(
              title,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: p.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[SizedBox(height: 20.h), action],
          ],
        ),
      ),
    );
  }
}
