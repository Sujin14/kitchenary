import 'package:kitchenary/services/notification_service.dart';

class ScheduledNotification {
  const ScheduledNotification(this.id, this.body, this.at);
  final int id;
  final String body;
  final DateTime at;
}

/// Records what would have been scheduled.
class FakeNotificationService implements NotificationService {
  FakeNotificationService({this.allowed = true});

  bool allowed;
  final Map<int, ScheduledNotification> scheduled = {};
  final List<int> cancelled = [];

  @override
  Future<bool> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
  }) async {
    if (!allowed) return false;
    scheduled[id] = ScheduledNotification(id, body, at);
    return true;
  }

  @override
  Future<void> cancel(int id) async {
    scheduled.remove(id);
    cancelled.add(id);
  }
}
