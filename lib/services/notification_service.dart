/// Shows a notification at a set time, even when the app is closed.
abstract interface class NotificationService {
  /// Schedules a notification for [at]. Returns false when it could not be
  /// scheduled (for example the user switched notifications off).
  Future<bool> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
  });

  Future<void> cancel(int id);
}
