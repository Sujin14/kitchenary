import 'package:flutter/material.dart';
import 'package:kitchenary/views/widgets/home/category_chip_row.dart';
import 'package:kitchenary/views/widgets/home/home_header.dart';
import 'package:kitchenary/views/widgets/home/home_search_bar.dart';
import 'package:kitchenary/views/widgets/home/recipe_feed.dart';
import 'package:kitchenary/views/widgets/home/subcategory_chip_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HomeHeader(),
            HomeSearchBar(),
            CategoryChipRow(),
            SubcategoryChipRow(),
            SizedBox(height: 14),
            Expanded(child: RecipeFeed()),
          ],
        ),
      ),
    );
  }
}
