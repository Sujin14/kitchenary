import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/views/widgets/home/category_chip_row.dart';
import 'package:kitchenary/views/widgets/home/home_header.dart';
import 'package:kitchenary/views/widgets/home/home_search_bar.dart';
import 'package:kitchenary/views/widgets/home/offline_banner.dart';
import 'package:kitchenary/views/widgets/home/recipe_feed.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            const HomeSearchBar(),
            const CategoryChipRow(),
            const OfflineBanner(),
            SizedBox(height: 14.h),
            const Expanded(child: RecipeFeed()),
          ],
        ),
      ),
    );
  }
}
