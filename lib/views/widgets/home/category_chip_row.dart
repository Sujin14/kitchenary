import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/home_controller.dart';
import 'package:kitchenary/models/recipe_category.dart';
import 'package:kitchenary/views/widgets/home/category_chip.dart';
import 'package:kitchenary/views/widgets/home/home_filter_button.dart';
import 'package:provider/provider.dart';

/// The Veg and Non-veg pills, with the filter button on the right.
class CategoryChipRow extends StatelessWidget {
  const CategoryChipRow({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SizedBox(
        height: 46.h,
        child: Row(
          children: [
            for (final category in RecipeCategory.diets) ...[
              CategoryChip(
                label: category.name,
                selected: home.selectedCategory == category,
                onTap: () =>
                    context.read<HomeController>().toggleDiet(category),
              ),
              SizedBox(width: 10.w),
            ],
            const Spacer(),
            const HomeFilterButton(),
          ],
        ),
      ),
    );
  }
}
