import 'package:flutter/material.dart';
import 'package:kitchenary/views/widgets/common/shimmer_scope.dart';
import 'package:kitchenary/views/widgets/common/skeleton_box.dart';

/// Shimmering stand-in while a photo downloads.
class ImageSkeleton extends StatelessWidget {
  const ImageSkeleton({this.width = double.infinity, this.height, super.key});

  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: SkeletonBox(width: width, height: height, radius: 0),
    );
  }
}
