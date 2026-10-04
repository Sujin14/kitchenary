import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/history_controller.dart';
import 'package:kitchenary/views/widgets/common/empty_state.dart';
import 'package:kitchenary/views/widgets/recipe/recipe_list_tile.dart';
import 'package:provider/provider.dart';

/// Recently viewed recipes, newest first.
class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryController>();
    if (history.isEmpty) {
      return const EmptyState(
        icon: Icons.history,
        title: 'No history yet',
        message: 'Recipes you open will show up here.',
      );
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      itemCount: history.count,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) =>
          RecipeListTile(recipe: history.recipes[index]),
    );
  }
}
