import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/history_controller.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/views/widgets/profile/settings_tile.dart';
import 'package:provider/provider.dart';

/// "Recently viewed" row with a count; opens the history screen.
class HistoryTile extends StatelessWidget {
  const HistoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select<HistoryController, int>((h) => h.count);
    return SettingsTile(
      icon: Icons.history,
      title: 'Recently viewed',
      subtitle: count == 0
          ? 'Nothing yet'
          : count == 1
              ? '1 recipe'
              : '$count recipes',
      onTap: () => context.openHistory(),
    );
  }
}
