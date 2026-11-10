import 'package:flutter/material.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/views/widgets/profile/settings_tile.dart';

// Opens Flutter's built-in page listing the licence notices of the packages
// and fonts the app uses.
class OpenSourceNoticesTile extends StatelessWidget {
  const OpenSourceNoticesTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: Icons.article_outlined,
      title: 'Open-source notices',
      onTap: () => showLicensePage(
        context: context,
        applicationName: AppConstants.appName,
        applicationVersion: AppConstants.appVersion,
      ),
    );
  }
}
