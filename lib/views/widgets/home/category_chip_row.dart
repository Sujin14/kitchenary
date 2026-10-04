import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/home_controller.dart';
import 'package:kitchenary/views/widgets/home/category_chip.dart';
import 'package:provider/provider.dart';

/// Horizontal list of top-level categories.
class CategoryChipRow extends StatelessWidget {
  const CategoryChipRow({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeController>();
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: home.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = home.categories[index];
          return CategoryChip(
            label: category.name,
            selected: home.selectedCategory == category,
            onTap: () => context.read<HomeController>().selectCategory(category),
          );
        },
      ),
    );
  }
}
