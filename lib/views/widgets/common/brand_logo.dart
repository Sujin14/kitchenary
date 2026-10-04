import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/constants/app_constants.dart';

/// The Kitchenary logo mark.
class BrandLogo extends StatelessWidget {
  const BrandLogo({this.size, super.key});

  /// Side length; defaults to 96 (scaled).
  final double? size;

  @override
  Widget build(BuildContext context) {
    final side = size ?? 96.r;
    return Image.asset(
      AppAssets.logoMark,
      width: side,
      height: side,
      semanticLabel: '${AppConstants.appName} logo',
    );
  }
}
