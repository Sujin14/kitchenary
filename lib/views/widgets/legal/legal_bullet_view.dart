import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/legal_document.dart';

// One bullet: a dot, then an optional bold label and the text.
class LegalBulletView extends StatelessWidget {
  const LegalBulletView({required this.bullet, super.key});

  final LegalBullet bullet;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final style = context.textTheme.bodyMedium?.copyWith(color: p.textPrimary);
    final fontSize = style?.fontSize ?? 14.sp;
    final label = bullet.label;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // Centres the dot on the first line of text.
          padding: EdgeInsets.only(
            top: fontSize * (style?.height ?? 1.4) / 2 - 3.r,
            left: 4.w,
            right: 10.w,
          ),
          child: Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                if (label != null)
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                TextSpan(text: bullet.text),
              ],
            ),
            style: style,
          ),
        ),
      ],
    );
  }
}
