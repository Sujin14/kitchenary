import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';

/// A titled group of chips inside the filter sheet.
class FilterChipSection extends StatelessWidget {
  const FilterChipSection({
    required this.title,
    required this.chips,
    super.key,
  });

  final String title;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textTheme.titleSmall),
          SizedBox(height: 10.h),
          Wrap(spacing: 8.w, runSpacing: 8.h, children: chips),
        ],
      ),
    );
  }
}
