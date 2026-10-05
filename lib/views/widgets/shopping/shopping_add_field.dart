import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/shopping_list_controller.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:provider/provider.dart';

/// Text box for adding an item by hand.
class ShoppingAddField extends StatefulWidget {
  const ShoppingAddField({super.key});

  @override
  State<ShoppingAddField> createState() => _ShoppingAddFieldState();
}

class _ShoppingAddFieldState extends State<ShoppingAddField> {
  final TextEditingController _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _text.text;
    if (name.trim().isEmpty) return;
    final added = await context.read<ShoppingListController>().addCustom(name);
    if (!mounted) return;
    if (added) {
      _text.clear();
    } else {
      AppSnackBar.show(context, 'Already on your list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
      child: TextField(
        controller: _text,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.sentences,
        onSubmitted: (_) => _add(),
        decoration: InputDecoration(
          hintText: 'Add an item',
          suffixIcon: IconButton(
            tooltip: 'Add item',
            icon: const Icon(Icons.add),
            onPressed: _add,
          ),
        ),
      ),
    );
  }
}
