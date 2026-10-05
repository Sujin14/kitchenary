import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kitchenary/views/widgets/navigation/app_bottom_bar.dart';

/// Hosts the five tabs and the bottom navigation bar.
class MainShellScreen extends StatelessWidget {
  const MainShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomBar(navigationShell: navigationShell),
    );
  }
}
