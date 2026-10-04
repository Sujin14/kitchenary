import 'package:flutter/material.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/views/widgets/profile/settings_tile.dart';

/// Shows the app version.
class VersionTile extends StatelessWidget {
  const VersionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsTile(
      icon: Icons.info_outline,
      title: 'Version',
      subtitle: AppConstants.appVersion,
    );
  }
}
