import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/settings_controller.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/views/widgets/common/brand_logo.dart';
import 'package:provider/provider.dart';

/// Logo, name and tagline; moves on after a short pause: to Home, or to the
/// welcome pages on the very first launch.
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
      if (context.read<SettingsController>().onboardingDone) {
        context.goHome();
      } else {
        context.goOnboarding();
      }
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
          BrandLogo(size: 112.r),
          SizedBox(height: 24.h),
          Text(
            AppConstants.appName,
            style: context.textTheme.displayMedium?.copyWith(color: p.primary),
          ),
          SizedBox(height: 8.h),
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
