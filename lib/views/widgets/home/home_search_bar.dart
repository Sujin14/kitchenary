import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/home_controller.dart';
import 'package:kitchenary/views/widgets/common/app_search_field.dart';
import 'package:provider/provider.dart';

/// The Home search box, wired to [HomeController].
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.read<HomeController>();
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 14.h),
      child: AppSearchField(
        hint: 'Search recipes, e.g. paneer',
        onChanged: home.onSearchChanged,
        onSubmitted: home.search,
        onCleared: home.clearSearch,
      ),
    );
  }
}
