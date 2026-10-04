import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/navigation/app_routes.dart';
import 'package:kitchenary/views/widgets/common/brand_logo.dart';

/// Logo, name and tagline; moves on to Home after a short pause.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppConstants.splashDuration, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BrandLogo(size: 112),
          const SizedBox(height: 24),
          Text(
            AppConstants.appName,
            style: context.textTheme.displayMedium?.copyWith(color: p.primary),
          ),
          const SizedBox(height: 8),
          Text(
            AppConstants.tagline,
            style: context.textTheme.bodyLarge?.copyWith(
              color: p.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
