import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';

/// One row in a settings card: icon, title, optional detail and a chevron.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.destructive = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  /// Draws the row in the error colour (for actions that delete things).
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = destructive ? p.error : p.textPrimary;
    final subtitle = this.subtitle;
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      leading: Icon(icon, color: destructive ? p.error : p.primary),
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(color: color),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: context.textTheme.bodySmall?.copyWith(
                color: p.textSecondary,
              ),
            ),
      trailing: onTap == null
          ? null
          : Icon(Icons.chevron_right, color: p.textHint),
    );
  }
}
