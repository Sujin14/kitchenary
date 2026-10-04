import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/onboarding_page.dart';

/// One onboarding page: a big icon, a title and a short message.
class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({required this.page, super.key});

  final OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 148.r,
            height: 148.r,
            decoration: BoxDecoration(
              color: p.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 68.sp, color: p.primary),
          ),
          SizedBox(height: 36.h),
          Text(
            page.title,
            style: context.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            page.message,
            style: context.textTheme.bodyLarge?.copyWith(
              color: p.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
