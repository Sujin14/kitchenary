import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/home_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/recipe_category.dart';
import 'package:kitchenary/models/recipe_filter.dart';
import 'package:kitchenary/views/widgets/home/category_chip.dart';
import 'package:kitchenary/views/widgets/home/filter_chip_section.dart';
import 'package:provider/provider.dart';

/// Opens the filter sheet.
Future<void> showHomeFilterSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const HomeFilterSheet(),
  );
}

/// Every filter except the Veg / Non-veg pills: cuisine and meals, vegetarian
/// ingredients and meats. Picking one closes the sheet and reloads the feed.
class HomeFilterSheet extends StatelessWidget {
  const HomeFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeController>();

    void close() => Navigator.of(context).pop();

    Widget subChip(RecipeCategory parent, RecipeFilter sub) {
      final selected =
          home.selectedCategory == parent && home.selectedSubcategory == sub;
      return CategoryChip(
        label: sub.label,
        compact: true,
        selected: selected,
        onTap: () {
          home.applyFilter(parent, selected ? null : sub);
          close();
        },
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Filters',
                      style: context.textTheme.headlineSmall,
                    ),
                  ),
                  if (home.hasActiveFilter)
                    TextButton(
                      onPressed: () {
                        home.clearFilters();
                        close();
                      },
                      child: const Text('Clear'),
                    ),
                ],
              ),
              FilterChipSection(
                title: 'Cuisine and meals',
                chips: [
                  for (final category in RecipeCategory.others)
                    CategoryChip(
                      label: category.name,
                      compact: true,
                      selected: home.selectedCategory == category &&
                          home.selectedSubcategory == null,
                      onTap: () {
                        home.applyFilter(category);
                        close();
                      },
                    ),
                ],
              ),
              FilterChipSection(
                title: 'Vegetarian ingredients',
                chips: [
                  for (final sub in RecipeCategory.veg.subcategories)
                    subChip(RecipeCategory.veg, sub),
                ],
              ),
              FilterChipSection(
                title: 'Non-veg',
                chips: [
                  for (final sub in RecipeCategory.nonVeg.subcategories)
                    subChip(RecipeCategory.nonVeg, sub),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
