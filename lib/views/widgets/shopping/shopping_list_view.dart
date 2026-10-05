import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/shopping_list_controller.dart';
import 'package:kitchenary/views/widgets/common/empty_state.dart';
import 'package:kitchenary/views/widgets/shopping/shopping_actions_row.dart';
import 'package:kitchenary/views/widgets/shopping/shopping_add_field.dart';
import 'package:kitchenary/views/widgets/shopping/shopping_item_tile.dart';
import 'package:provider/provider.dart';

/// Add box, actions and the items; a friendly message when the list is empty.
class ShoppingListView extends StatelessWidget {
  const ShoppingListView({super.key});

  @override
  Widget build(BuildContext context) {
    final list = context.watch<ShoppingListController>();
    final items = list.items;
    return Column(
      children: [
        const ShoppingAddField(),
        if (!list.isEmpty) const ShoppingActionsRow(),
        Expanded(
          child: list.isEmpty
              ? const EmptyState(
                  icon: Icons.shopping_basket_outlined,
                  title: 'Your list is empty',
                  message: 'Add items above, or open a recipe and tap '
                      '"Add to shopping list".',
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) =>
                      ShoppingItemTile(item: items[index]),
                ),
        ),
      ],
    );
  }
}
