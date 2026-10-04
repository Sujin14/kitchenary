import 'package:flutter/material.dart';
import 'package:kitchenary/core/constants/app_constants.dart';

/// The Kitchenary logo mark.
class BrandLogo extends StatelessWidget {
  const BrandLogo({this.size = 96, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logoMark,
      width: size,
      height: size,
      semanticLabel: '${AppConstants.appName} logo',
    );
  }
}
