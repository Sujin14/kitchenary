import 'package:flutter/material.dart';

/// Asks for the user's name. Use [show]; it returns the text, or null if
/// the dialog was cancelled.
class EditNameDialog extends StatefulWidget {
  const EditNameDialog({required this.initialName, super.key});

  final String initialName;

  static Future<String?> show(BuildContext context, String initialName) =>
      showDialog<String>(
        context: context,
        builder: (_) => EditNameDialog(initialName: initialName),
      );

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your name'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 30,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(hintText: 'What should we call you?'),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
