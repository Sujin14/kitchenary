import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/core/utils/duration_format.dart';
import 'package:kitchenary/core/utils/step_duration_parser.dart';

void main() {
  List<Duration> durations(String text) =>
      StepDurationParser.find(text).map((d) => d.duration).toList();

  group('StepDurationParser', () {
    test('finds minutes, hours and seconds', () {
      expect(durations('Simmer for 10 minutes.'), [const Duration(minutes: 10)]);
      expect(durations('Cook 2 hrs on low.'), [const Duration(hours: 2)]);
      expect(durations('Rest 30 seconds.'), [const Duration(seconds: 30)]);
      expect(durations('Boil 5 mins'), [const Duration(minutes: 5)]);
    });

    test('uses the shorter end of a range', () {
      expect(durations('Fry 10-15 minutes'), [const Duration(minutes: 10)]);
      expect(durations('Bake 20 to 25 minutes'), [const Duration(minutes: 20)]);
    });

    test('reads fractions and decimals', () {
      expect(durations('Marinate 1 1/2 hours'), [const Duration(minutes: 90)]);
      expect(durations('Cook 1.5 hours'), [const Duration(minutes: 90)]);
      expect(durations('Wait 1/2 hour'), [const Duration(minutes: 30)]);
    });

    test('joins hours and minutes', () {
      final found = StepDurationParser.find('Roast 1 hour 30 minutes.');
      expect(found, hasLength(1));
      expect(found.single.duration, const Duration(minutes: 90));
      expect(found.single.text, '1 hour 30 minutes');
      expect(durations('Roast 1 hour and 15 minutes'), [
        const Duration(minutes: 75),
      ]);
    });

    test('reads number words and half an hour', () {
      expect(durations('Simmer for ten minutes.'), [const Duration(minutes: 10)]);
      expect(durations('Leave for an hour.'), [const Duration(hours: 1)]);
      expect(durations('Rest half an hour.'), [const Duration(minutes: 30)]);
      expect(durations('Wait a minute.'), [const Duration(minutes: 1)]);
      expect(durations('Boil for Twenty Minutes'), [const Duration(minutes: 20)]);
    });

    test('ignores temperatures and plain numbers', () {
      expect(durations('Heat oven to 180 degrees. Add 2 onions.'), isEmpty);
    });

    test('removes repeats and caps the list', () {
      expect(durations('Boil 5 minutes, then 5 minutes more.'), [
        const Duration(minutes: 5),
      ]);
      expect(
        durations('1 minute, 2 minutes, 3 minutes, 4 minutes'),
        hasLength(StepDurationParser.maxResults),
      );
    });
  });

  group('DurationFormat', () {
    test('clock', () {
      expect(DurationFormat.clock(const Duration(minutes: 9, seconds: 5)), '09:05');
      expect(DurationFormat.clock(const Duration(hours: 1, minutes: 30)), '1:30:00');
      expect(DurationFormat.clock(const Duration(milliseconds: 100)), '00:01');
      expect(DurationFormat.clock(Duration.zero), '00:00');
    });

    test('words', () {
      expect(DurationFormat.words(const Duration(minutes: 10)), '10 min');
      expect(DurationFormat.words(const Duration(minutes: 90)), '1 hr 30 min');
      expect(DurationFormat.words(const Duration(seconds: 45)), '45 sec');
    });
  });
}
