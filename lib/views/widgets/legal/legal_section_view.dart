import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/legal_document.dart';
import 'package:kitchenary/views/widgets/legal/legal_bullet_list_view.dart';
import 'package:kitchenary/views/widgets/legal/legal_paragraph_view.dart';

// One heading followed by its paragraphs and bullet lists.
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
          Text(
            section.heading,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.palette.textPrimary,
            ),
          ),
          for (final block in section.blocks) ...[
            SizedBox(height: 8.h),
            switch (block) {
              LegalParagraph() => LegalParagraphView(paragraph: block),
              LegalBulletList() => LegalBulletListView(list: block),
            },
          ],
        ],
      ),
    );
  }
}
