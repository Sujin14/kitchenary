import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/order_controller.dart';
import 'package:kitchenary/core/constants/grocery_stores.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';

/// First step: which store to order from.
class OrderStoreChooser extends StatelessWidget {
  const OrderStoreChooser({super.key});

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderController>();
    final p = context.palette;
    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        Text(
          'Where do you want to order?',
          style: context.textTheme.headlineSmall,
        ),
        SizedBox(height: 8.h),
        Text(
          'Pick one store so all ${order.total} items go into a single cart '
          'and a single delivery. We will take you through the list one item '
          'at a time.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: p.textSecondary,
          ),
        ),
        SizedBox(height: 16.h),
        for (final store in GroceryStores.all)
          Card(
            child: ListTile(
              leading: Icon(Icons.storefront_outlined, color: p.primary),
              title: Text(store.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => order.chooseStore(store),
            ),
          ),
      ],
    );
  }
}
