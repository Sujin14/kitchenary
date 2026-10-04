import 'package:flutter/material.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/views/widgets/common/section_title.dart';
import 'package:kitchenary/views/widgets/details/numbered_step.dart';

/// The cooking method as numbered steps.
class InstructionSection extends StatelessWidget {
  const InstructionSection({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Method'),
        const SizedBox(height: 12),
        if (recipe.hasSteps)
          for (var i = 0; i < recipe.steps.length; i++)
            NumberedStep(number: i + 1, text: recipe.steps[i])
        else
          Text(
            'No written method for this recipe.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.palette.textSecondary,
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
