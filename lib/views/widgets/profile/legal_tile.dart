import 'package:flutter/material.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/views/widgets/profile/settings_tile.dart';

/// A row that opens one of the legal documents (see `LegalContent`).
class LegalTile extends StatelessWidget {
  const LegalTile({
    required this.icon,
    required this.title,
    required this.slug,
    super.key,
  });

  final IconData icon;
  final String title;
  final String slug;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: icon,
      title: title,
      onTap: () => context.openLegal(slug),
    );
  }
}
