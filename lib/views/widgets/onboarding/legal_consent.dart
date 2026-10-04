import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/constants/legal_content.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';

/// "By continuing you agree to our Terms of Use and Privacy Policy" with
/// both names opening the documents.
class LegalConsent extends StatelessWidget {
  const LegalConsent({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final link = TextButton.styleFrom(
      minimumSize: Size.zero,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: context.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
    final plain = context.textTheme.bodySmall?.copyWith(
      color: p.textSecondary,
    );
    return Column(
      children: [
        Text('By continuing you agree to our', style: plain),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: link,
              onPressed: () => context.openLegal(LegalContent.slugTerms),
              child: const Text('Terms of Use'),
            ),
            Text('and', style: plain),
            TextButton(
              style: link,
              onPressed: () => context.openLegal(LegalContent.slugPrivacy),
              child: const Text('Privacy Policy'),
            ),
          ],
        ),
      ],
    );
  }
}
