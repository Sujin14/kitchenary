import 'package:flutter/material.dart';

/// Shows a short message at the bottom of the screen.
abstract final class AppSnackBar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
