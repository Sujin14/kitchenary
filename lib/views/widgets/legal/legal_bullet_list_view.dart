import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/models/legal_document.dart';
import 'package:kitchenary/views/widgets/legal/legal_bullet_view.dart';

// A bulleted list in a legal document.
class LegalBulletListView extends StatelessWidget {
  const LegalBulletListView({required this.list, super.key});

  final LegalBulletList list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < list.items.length; i++) ...[
          if (i > 0) SizedBox(height: 6.h),
          LegalBulletView(bullet: list.items[i]),
        ],
      ],
    );
  }
}
