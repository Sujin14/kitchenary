import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/core/utils/quantity_scaler.dart';

void main() {
  String scale(String measure, double factor) =>
      QuantityScaler.scale(measure, factor);

  group('whole numbers and units', () {
    test('multiplies a number that touches its unit', () {
      expect(scale('200g', 2), '400g');
      expect(scale('2', 3), '6');
    });

    test('keeps the spacing and unit text', () {
      expect(scale('2 tbsp', 2), '4 tbsp');
      expect(scale('3 cloves', 2), '6 cloves');
    });

    test('a factor of one returns the measure untouched', () {
      expect(scale('1/4 cup', 1), '1/4 cup');
      expect(scale('  1 cup ', 1), '1 cup');
    });
  });

  group('fractions', () {
    test('mixed numbers', () {
      expect(scale('1 1/2 cup', 2), '3 cup');
      expect(scale('1 1/2 cup', 0.5), '3/4 cup');
    });

    test('plain fractions grow into mixed numbers', () {
      expect(scale('1/2 tsp', 3), '1 1/2 tsp');
    });

    test('snaps to kitchen fractions', () {
      expect(scale('1 cup', 1 / 3), '1/3 cup');
      expect(scale('1 cup', 2 / 3), '2/3 cup');
      expect(scale('1 tbsp', 0.1), '1/8 tbsp');
    });

    test('unicode fractions are understood', () {
      expect(scale('½ cup', 2), '1 cup');
      expect(scale('1½ cups', 2), '3 cups');
    });

    test('decimals', () {
      expect(scale('1.5 cup', 2), '3 cup');
    });

    test('counts can become halves', () {
      expect(scale('3 cloves', 0.5), '1 1/2 cloves');
    });
  });

  group('ranges', () {
    test('both ends are scaled', () {
      expect(scale('2-3 tbsp', 2), '4-6 tbsp');
      expect(scale('2 to 3 tbsp', 2), '4-6 tbsp');
    });
  });

  group('metric units', () {
    test('round to sensible numbers', () {
      expect(scale('120g', 1.5), '180g');
      expect(scale('125g', 1.6), '200g');
      expect(scale('3g', 2.5), '7.5g');
      expect(scale('45 ml', 2), '90 ml');
    });

    test('grams and millilitres switch to kg and litres', () {
      expect(scale('600g', 2), '1.2kg');
      expect(scale('250 ml', 4), '1 l');
    });

    test('an alternative unit after a slash is dropped', () {
      expect(scale('400g/14oz', 2), '800g');
    });
  });

  group('left alone', () {
    test('measures without a leading number', () {
      expect(scale('to taste', 2), 'to taste');
      expect(scale('Juice of 1', 2), 'Juice of 1');
      expect(scale('Pinch', 3), 'Pinch');
      expect(scale('', 2), '');
    });

    test('numbers that are not the amount', () {
      expect(scale('1 (14 oz) can', 2), '2 (14 oz) can');
    });

    test('a factor that makes no sense returns the original', () {
      expect(scale('2 cups', 0), '2 cups');
      expect(scale('2 cups', -1), '2 cups');
    });
  });
}
