import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/order_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/services/url_launcher_service.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:kitchenary/views/widgets/common/primary_button.dart';
import 'package:kitchenary/views/widgets/common/secondary_button.dart';
import 'package:provider/provider.dart';

/// Last step: open the store, check the cart, place one order.
class OrderDonePage extends StatelessWidget {
  const OrderDonePage({super.key});

  Future<void> _openStore(BuildContext context) async {
    final store = context.read<OrderController>().store;
    if (store == null) return;
    final opened = await context.read<UrlLauncherService>().open(store.homeUrl);
    if (!opened && context.mounted) {
      AppSnackBar.show(context, 'Could not open ${store.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderController>();
    final store = order.store;
    if (store == null) return const SizedBox.shrink();
    final p = context.palette;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_checkout, size: 64.sp, color: p.primary),
            SizedBox(height: 16.h),
            Text(
              'Time to place your order',
              style: context.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Open ${store.name}, check that everything is in your cart, '
              'and place one order for all of it.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: p.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            PrimaryButton(
              label: 'Open ${store.name}',
              icon: Icons.open_in_new,
              onPressed: () => _openStore(context),
            ),
            SizedBox(height: 12.h),
            SecondaryButton(
              label: 'Back to my list',
              onPressed: context.popOrHome,
            ),
          ],
        ),
      ),
    );
  }
}
