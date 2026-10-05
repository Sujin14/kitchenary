import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/offline_status_controller.dart';

void main() {
  test('notifies only when the state changes', () {
    final status = OfflineStatusController();
    var calls = 0;
    status.addListener(() => calls++);

    status.markOnline();
    expect(calls, 0);
    status.markOffline();
    status.markOffline();
    expect(calls, 1);
    expect(status.isOffline, isTrue);
    status.markOnline();
    expect(calls, 2);
  });
}
