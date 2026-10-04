import 'package:flutter/material.dart';
import 'package:kitchenary/models/recipe.dart';
import 'package:kitchenary/services/url_launcher_service.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:kitchenary/views/widgets/common/secondary_button.dart';
import 'package:provider/provider.dart';

/// Opens the recipe's video walkthrough, when there is one.
class VideoLinkButton extends StatelessWidget {
  const VideoLinkButton({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    if (!recipe.hasVideo) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: SecondaryButton(
        label: 'Watch the video',
        icon: Icons.play_circle_outline,
        onPressed: () async {
          final opened =
              await context.read<UrlLauncherService>().open(recipe.videoUrl);
          if (!opened && context.mounted) {
            AppSnackBar.show(context, 'Could not open the video.');
          }
        },
      ),
    );
  }
}
