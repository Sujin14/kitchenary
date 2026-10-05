import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/order_controller.dart';
import 'package:kitchenary/views/widgets/common/empty_state.dart';
import 'package:kitchenary/views/widgets/order/order_done_page.dart';
import 'package:kitchenary/views/widgets/order/order_item_page.dart';
import 'package:kitchenary/views/widgets/order/order_store_chooser.dart';
import 'package:provider/provider.dart';

/// Shows the right step: nothing to order, choose a store, an item, or done.
class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderController>();
    if (!order.hasItems) {
      return const EmptyState(
        icon: Icons.shopping_basket_outlined,
        title: 'Nothing to order',
        message: 'Everything on your list is ticked off, or the list is empty.',
      );
    }
    if (!order.hasStore) return const OrderStoreChooser();
    if (order.isDone) return const OrderDonePage();
    return const OrderItemPage();
  }
}
