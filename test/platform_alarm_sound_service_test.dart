import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/services/platform_alarm_sound_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel(PlatformAlarmSoundService.channelName);
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const service = PlatformAlarmSoundService();

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('play and stop call the Android side', () async {
    final calls = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      return null;
    });

    await service.play();
    await service.stop();

    expect(calls, ['play', 'stop']);
  });

  test('platform failures are swallowed', () async {
    messenger.setMockMethodCallHandler(
      channel,
      (_) async => throw PlatformException(code: 'no_sound'),
    );

    await expectLater(service.play(), completes);
    await expectLater(service.stop(), completes);
  });

  test('a missing Android side is ignored', () async {
    await expectLater(service.play(), completes);
    await expectLater(service.stop(), completes);
  });
}
