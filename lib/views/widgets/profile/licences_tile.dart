import 'package:flutter/material.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/views/widgets/profile/settings_tile.dart';

/// Opens Flutter's built-in open-source licences page.
class LicencesTile extends StatelessWidget {
  const LicencesTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: Icons.code,
      title: 'Open-source licences',
      onTap: () => showLicensePage(
        context: context,
        applicationName: AppConstants.appName,
        applicationVersion: AppConstants.appVersion,
      ),
    );
  }
}
