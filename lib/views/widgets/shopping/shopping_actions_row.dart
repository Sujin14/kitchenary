import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/shopping_list_controller.dart';
import 'package:kitchenary/core/navigation/app_navigation.dart';
import 'package:kitchenary/services/clipboard_service.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:kitchenary/views/widgets/common/secondary_button.dart';
import 'package:provider/provider.dart';

/// Copy the list, order it step by step, or clear what is ticked.
class ShoppingActionsRow extends StatelessWidget {
  const ShoppingActionsRow({super.key});

  Future<void> _copy(BuildContext context) async {
    final text = context.read<ShoppingListController>().asText();
    await context.read<ClipboardService>().copy(text);
    if (!context.mounted) return;
    AppSnackBar.show(context, 'List copied');
  }

  @override
  Widget build(BuildContext context) {
    final list = context.watch<ShoppingListController>();
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Copy list',
                  icon: Icons.copy_outlined,
                  onPressed:
                      list.remainingCount == 0 ? null : () => _copy(context),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: SecondaryButton(
                  label: 'Order online',
                  icon: Icons.storefront_outlined,
                  onPressed:
                      list.remainingCount == 0 ? null : context.openOrder,
                ),
              ),
            ],
          ),
          if (list.hasChecked)
            TextButton(
              onPressed: list.clearChecked,
              child: const Text('Clear ticked'),
            ),
        ],
      ),
    );
  }
}
