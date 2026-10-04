import 'package:flutter/material.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:shimmer/shimmer.dart';

/// Animates every [SkeletonBox] below it with a moving highlight.
///
/// Put it around the skeleton blocks only, never around cards or borders,
/// because the shimmer replaces the colour of everything it paints.
class ShimmerScope extends StatelessWidget {
  const ShimmerScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Shimmer.fromColors(
      baseColor: p.shimmerBase,
      highlightColor: p.shimmerHighlight,
      child: child,
    );
  }
}
