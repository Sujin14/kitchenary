import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/order_controller.dart';
import 'package:kitchenary/controllers/shopping_list_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/services/url_launcher_service.dart';
import 'package:kitchenary/views/widgets/common/app_card.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:kitchenary/views/widgets/common/primary_button.dart';
import 'package:kitchenary/views/widgets/common/secondary_button.dart';
import 'package:provider/provider.dart';

/// One item: search it in the store, add it to the cart, move on.
class OrderItemPage extends StatelessWidget {
  const OrderItemPage({super.key});

  Future<void> _search(BuildContext context) async {
    final order = context.read<OrderController>();
    final item = order.current;
    final store = order.store;
    if (item == null || store == null) return;
    final opened = await context.read<UrlLauncherService>().open(
          store.searchFor(item.name),
        );
    if (!opened && context.mounted) {
      AppSnackBar.show(context, 'Could not open ${store.name}');
    }
  }

  Future<void> _added(BuildContext context) async {
    final order = context.read<OrderController>();
    final list = context.read<ShoppingListController>();
    final item = order.current;
    if (item == null) return;
    order.next();
    await list.setChecked(item.id, checked: true);
  }

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderController>();
    final item = order.current;
    final store = order.store;
    if (item == null || store == null) return const SizedBox.shrink();
    final p = context.palette;
    final detail = [item.measure, item.recipeTitle]
        .where((part) => part.isNotEmpty)
        .join(' · ');

    return ListView(
      padding: EdgeInsets.all(20.r),
      children: [
        Text(
          'Item ${order.position} of ${order.total} · ${store.name}',
          style: context.textTheme.titleSmall?.copyWith(color: p.primary),
        ),
        SizedBox(height: 10.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(
            value: order.progress,
            minHeight: 8.h,
            color: p.primary,
            backgroundColor: p.primarySoft,
          ),
        ),
        SizedBox(height: 24.h),
        AppCard(
          padding: EdgeInsets.all(20.r),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: context.textTheme.headlineMedium),
                if (detail.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Text(
                    detail,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: p.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Search it on ${store.name}, add it to your cart, then come back '
          'here for the next item. You place one order at the end.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: p.textSecondary,
          ),
        ),
        SizedBox(height: 24.h),
        PrimaryButton(
          label: 'Search on ${store.name}',
          icon: Icons.search,
          onPressed: () => _search(context),
        ),
        SizedBox(height: 12.h),
        SecondaryButton(
          label: 'Added to cart, next item',
          icon: Icons.check,
          onPressed: () => _added(context),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            TextButton(
              onPressed: order.isFirst ? null : order.previous,
              child: const Text('Back'),
            ),
            const Spacer(),
            TextButton(onPressed: order.next, child: const Text('Skip')),
          ],
        ),
        TextButton(
          onPressed: order.changeStore,
          child: const Text('Change store'),
        ),
      ],
    );
  }
}
