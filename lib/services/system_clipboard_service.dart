import 'package:flutter/services.dart';
import 'package:kitchenary/services/clipboard_service.dart';

/// `ClipboardService` backed by the system clipboard.
class SystemClipboardService implements ClipboardService {
  const SystemClipboardService();

  @override
  Future<void> copy(String text) => Clipboard.setData(ClipboardData(text: text));
}
