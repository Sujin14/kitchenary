import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/offline_status_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';

/// Tells the user the recipes shown are the copy kept on the phone.
/// Hidden while the recipe service can be reached.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final offline = context.select<OfflineStatusController, bool>(
      (status) => status.isOffline,
    );
    if (!offline) return const SizedBox.shrink();
    final p = context.palette;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: p.accentSoft,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.cloud_off_outlined, size: 20.sp, color: p.textPrimary),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'Could not reach the recipe service. Showing recipes saved '
                'on this phone.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: p.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
