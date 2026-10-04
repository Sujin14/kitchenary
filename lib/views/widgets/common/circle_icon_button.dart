import 'package:flutter/material.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';

/// A round icon button that stays legible over photos.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(color: p.overlayControl, shape: BoxShape.circle),
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon),
        color: p.textPrimary,
        onPressed: onPressed,
      ),
    );
  }
}
