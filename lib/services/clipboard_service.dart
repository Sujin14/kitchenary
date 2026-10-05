/// Puts text on the phone's clipboard.
abstract interface class ClipboardService {
  Future<void> copy(String text);
}
