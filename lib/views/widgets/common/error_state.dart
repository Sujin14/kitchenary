import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/views/widgets/common/secondary_button.dart';

/// Error message with a retry button.
class ErrorState extends StatelessWidget {
  const ErrorState({required this.message, required this.onRetry, super.key});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 56.sp, color: p.textHint),
            SizedBox(height: 16.h),
            Text(
              message,
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: 180.w,
              child: SecondaryButton(
                label: 'Try again',
                icon: Icons.refresh,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
