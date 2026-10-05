import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/constants/grocery_stores.dart';
import 'package:kitchenary/core/extensions/context_extensions.dart';
import 'package:kitchenary/models/grocery_store.dart';

/// Asks which grocery store to open. Calls [onPicked] after the sheet closes.
Future<void> showStorePicker(
  BuildContext context, {
  required String title,
  required ValueChanged<GroceryStore> onPicked,
}) async {
  final store = await showModalBottomSheet<GroceryStore>(
    context: context,
    showDragHandle: true,
    builder: (_) => StorePickerSheet(title: title),
  );
  if (store != null) onPicked(store);
}

/// The list of grocery stores, one tap each.
class StorePickerSheet extends StatelessWidget {
  const StorePickerSheet({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
              child: Text(title, style: context.textTheme.titleLarge),
            ),
            for (final store in GroceryStores.all)
              ListTile(
                leading: Icon(Icons.storefront_outlined, color: p.primary),
                title: Text(store.name),
                trailing: const Icon(Icons.open_in_new, size: 20),
                onTap: () => Navigator.of(context).pop(store),
              ),
          ],
        ),
      ),
    );
  }
}
