import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/views/widgets/common/image_skeleton.dart';

/// A network image with a shimmer placeholder and an error fallback.
class RecipeImage extends StatelessWidget {
  const RecipeImage({
    required this.url,
    this.height,
    this.width = double.infinity,
    super.key,
  });

  final String url;
  final double? height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final fallback = Container(
      width: width,
      height: height,
      color: p.surfaceMuted,
      child: Icon(Icons.restaurant, color: p.textHint, size: 36.sp),
    );

    if (url.isEmpty) return fallback;

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (_, _) => ImageSkeleton(width: width, height: height),
      errorWidget: (_, _, _) => fallback,
    );
  }
}
