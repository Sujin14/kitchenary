import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/home_controller.dart';
import 'package:kitchenary/views/widgets/home/category_chip.dart';
import 'package:provider/provider.dart';

/// Sub-chips (ingredients or meats) for the selected category.
class SubcategoryChipRow extends StatelessWidget {
  const SubcategoryChipRow({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeController>();
    final subs = home.selectedCategory?.subcategories ?? const [];
    if (subs.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: SizedBox(
        height: 38.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: subs.length,
          separatorBuilder: (_, _) => SizedBox(width: 8.w),
          itemBuilder: (context, index) {
            final sub = subs[index];
            return CategoryChip(
              label: sub.label,
              compact: true,
              selected: home.selectedSubcategory == sub,
              onTap: () =>
                  context.read<HomeController>().selectSubcategory(sub),
            );
          },
        ),
      ),
    );
  }
}
