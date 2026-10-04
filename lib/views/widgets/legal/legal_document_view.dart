import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/legal_document.dart';
import 'package:kitchenary/views/widgets/legal/legal_section_view.dart';

/// A scrollable legal document: date, introduction and sections.
class LegalDocumentView extends StatelessWidget {
  const LegalDocumentView({required this.document, super.key});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 40.h),
      children: [
        Text(
          'Last updated: ${document.updated}',
          style: context.textTheme.bodySmall?.copyWith(color: p.textHint),
        ),
        SizedBox(height: 12.h),
        Text(document.intro, style: context.textTheme.bodyLarge),
        for (final section in document.sections)
          LegalSectionView(section: section),
      ],
    );
  }
}
