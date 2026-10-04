import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/history_controller.dart';
import 'package:kitchenary/views/widgets/common/app_snack_bar.dart';
import 'package:kitchenary/views/widgets/common/confirm_dialog.dart';
import 'package:provider/provider.dart';

/// App-bar action that clears the viewing history (after confirming).
class ClearHistoryButton extends StatelessWidget {
  const ClearHistoryButton({super.key});

  Future<void> _clear(BuildContext context) async {
    final history = context.read<HistoryController>();
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Clear history?',
      message: 'Your recently viewed recipes will be removed.',
      confirmLabel: 'Clear',
    );
    if (!confirmed) return;
    await history.clear();
    if (!context.mounted) return;
    AppSnackBar.show(context, 'History cleared');
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty =
        context.select<HistoryController, bool>((history) => history.isEmpty);
    return IconButton(
      tooltip: 'Clear history',
      icon: const Icon(Icons.delete_outline),
      onPressed: isEmpty ? null : () => _clear(context),
    );
  }
}
