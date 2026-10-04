import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';

/// A solid placeholder block. Use inside a [ShimmerScope].
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    this.width,
    this.height,
    this.radius,
    this.circle = false,
    super.key,
  });

  final double? width;
  final double? height;

  /// Corner radius; defaults to 8 (scaled).
  final double? radius;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // Any opaque colour works: the shimmer paints over it.
        color: context.palette.surface,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(radius ?? 8.r),
      ),
    );
  }
}
