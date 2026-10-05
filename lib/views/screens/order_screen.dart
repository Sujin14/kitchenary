import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/order_controller.dart';
import 'package:kitchenary/controllers/shopping_list_controller.dart';
import 'package:kitchenary/views/widgets/order/order_view.dart';
import 'package:provider/provider.dart';

/// Guided ordering: pick a store, then add each item to one cart.
class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderController>(
      create: (context) => OrderController(
        context
            .read<ShoppingListController>()
            .items
            .where((item) => !item.checked),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Order groceries')),
        body: const SafeArea(child: OrderView()),
      ),
    );
  }
}
