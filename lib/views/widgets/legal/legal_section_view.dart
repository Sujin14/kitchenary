import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/legal_document.dart';

/// One heading and its paragraphs.
class LegalSectionView extends StatelessWidget {
  const LegalSectionView({required this.section, super.key});

  final LegalSection section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.heading, style: context.textTheme.titleMedium),
          for (final paragraph in section.paragraphs) ...[
            SizedBox(height: 8.h),
            Text(paragraph, style: context.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
