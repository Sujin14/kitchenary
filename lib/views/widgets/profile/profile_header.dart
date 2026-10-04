import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/settings_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/views/widgets/common/app_card.dart';
import 'package:kitchenary/views/widgets/profile/edit_name_dialog.dart';
import 'package:provider/provider.dart';

/// Avatar with the user's initial, their name, and a tap to change it.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  Future<void> _editName(BuildContext context) async {
    final settings = context.read<SettingsController>();
    final name = await EditNameDialog.show(context, settings.userName);
    if (name == null) return;
    await settings.setUserName(name);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final p = context.palette;
    return AppCard(
      onTap: () => _editName(context),
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: p.primarySoft,
            child: settings.hasName
                ? Text(
                    settings.initial,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: p.primary,
                    ),
                  )
                : Icon(Icons.person, color: p.primary, size: 30.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  settings.hasName ? settings.userName : 'Welcome, cook',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleLarge,
                ),
                SizedBox(height: 2.h),
                Text(
                  settings.hasName
                      ? 'Tap to change your name'
                      : 'Tap to add your name',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: p.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.edit_outlined, color: p.textHint),
        ],
      ),
    );
  }
}
