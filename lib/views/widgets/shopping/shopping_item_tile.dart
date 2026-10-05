import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/shopping_list_controller.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/shopping_item.dart';
import 'package:kitchenary/services/url_launcher_service.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:kitchenary/views/widgets/shopping/store_picker_sheet.dart';
import 'package:provider/provider.dart';

/// One shopping list row: tick it off, swipe to remove, or look it up in a
/// grocery store.
class ShoppingItemTile extends StatelessWidget {
  const ShoppingItemTile({required this.item, super.key});

  final ShoppingItem item;

  String get _subtitle => [item.measure, item.recipeTitle]
      .where((part) => part.isNotEmpty)
      .join(' · ');

  Future<void> _findInStore(BuildContext context) {
    final launcher = context.read<UrlLauncherService>();
    return showStorePicker(
      context,
      title: 'Find ${item.name} on',
      onPicked: (store) async {
        final opened = await launcher.open(store.searchFor(item.name));
        if (!opened && context.mounted) {
          AppSnackBar.show(context, 'Could not open ${store.name}');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final list = context.read<ShoppingListController>();
    final subtitle = _subtitle;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => list.remove(item.id),
      background: Container(
        color: p.error,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.w),
        child: Icon(Icons.delete_outline, color: p.onError),
      ),
      child: InkWell(
        onTap: () => list.toggle(item.id),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          child: Row(
            children: [
              Checkbox(
                value: item.checked,
                onChanged: (_) => list.toggle(item.id),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: item.checked ? p.textHint : p.textPrimary,
                        decoration:
                            item.checked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: p.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Find in a grocery store',
                color: p.primary,
                icon: const Icon(Icons.storefront_outlined),
                onPressed: () => _findInStore(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
