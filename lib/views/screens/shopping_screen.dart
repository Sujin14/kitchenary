import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/shopping_list_controller.dart';
import 'package:kitchenary/views/widgets/common/screen_header.dart';
import 'package:kitchenary/views/widgets/shopping/shopping_list_view.dart';
import 'package:provider/provider.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final remaining = context.select<ShoppingListController, int>(
      (list) => list.remainingCount,
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Shopping',
              subtitle: remaining == 0 ? 'Nothing to buy' : '$remaining to buy',
            ),
            const Expanded(child: ShoppingListView()),
          ],
        ),
      ),
    );
  }
}
