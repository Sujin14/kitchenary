import 'package:flutter/material.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/legal_document.dart';

// A plain paragraph in a legal document.
class LegalParagraphView extends StatelessWidget {
  const LegalParagraphView({required this.paragraph, super.key});

  final LegalParagraph paragraph;

  @override
  Widget build(BuildContext context) {
    return Text(
      paragraph.text,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.palette.textPrimary,
      ),
    );
  }
}
