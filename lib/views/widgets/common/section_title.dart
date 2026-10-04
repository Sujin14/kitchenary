import 'package:flutter/material.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: context.textTheme.headlineSmall);
  }
}
