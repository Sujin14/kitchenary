import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/settings_controller.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/models/onboarding_page.dart';
import 'package:kitchenary/views/widgets/common/primary_button.dart';
import 'package:kitchenary/views/widgets/onboarding/legal_consent.dart';
import 'package:kitchenary/views/widgets/onboarding/onboarding_page_content.dart';
import 'package:kitchenary/views/widgets/onboarding/page_dots.dart';
import 'package:provider/provider.dart';

/// The three-page welcome flow, shown once on first launch.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  static const _pages = OnboardingPage.pages;

  final PageController _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final settings = context.read<SettingsController>();
    await settings.completeOnboarding();
    if (!mounted) return;
    context.goHome();
  }

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 8.h, 12.w, 0),
            child: TextButton(
              onPressed: _isLast ? null : _finish,
              child: Text(_isLast ? '' : 'Skip'),
            ),
          ),
        ),
        Expanded(
          child: PageView(
            controller: _controller,
            onPageChanged: (index) => setState(() => _index = index),
            children: [
              for (final page in _pages) OnboardingPageContent(page: page),
            ],
          ),
        ),
        PageDots(count: _pages.length, index: _index),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: PrimaryButton(
            label: _isLast ? 'Get started' : 'Next',
            onPressed: _next,
          ),
        ),
        SizedBox(height: 12.h),
        const LegalConsent(),
        SizedBox(height: 16.h),
      ],
    );
  }
}
