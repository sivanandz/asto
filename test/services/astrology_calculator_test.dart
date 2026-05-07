import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/planet_position.dart';
import '../../lib/services/astrology_calculator.dart';

void main() {
  group('AstrologyCalculator.getHouseLord', () {
    test('should return correct lord for house 1 (Aries)', () {
      expect(AstrologyCalculator.getHouseLord(1), PlanetType.mars);
    });

    test('should return correct lord for house 2 (Taurus)', () {
      expect(AstrologyCalculator.getHouseLord(2), PlanetType.venus);
    });

    test('should return correct lord for house 3 (Gemini)', () {
      expect(AstrologyCalculator.getHouseLord(3), PlanetType.mercury);
    });

    test('should return correct lord for house 4 (Cancer)', () {
      expect(AstrologyCalculator.getHouseLord(4), PlanetType.moon);
    });

    test('should return correct lord for house 5 (Leo)', () {
      expect(AstrologyCalculator.getHouseLord(5), PlanetType.sun);
    });

    test('should return correct lord for house 6 (Virgo)', () {
      expect(AstrologyCalculator.getHouseLord(6), PlanetType.mercury);
    });

    test('should return correct lord for house 7 (Libra)', () {
      expect(AstrologyCalculator.getHouseLord(7), PlanetType.venus);
    });

    test('should return correct lord for house 8 (Scorpio)', () {
      expect(AstrologyCalculator.getHouseLord(8), PlanetType.mars);
    });

    test('should return correct lord for house 9 (Sagittarius)', () {
      expect(AstrologyCalculator.getHouseLord(9), PlanetType.jupiter);
    });

    test('should return correct lord for house 10 (Capricorn)', () {
      expect(AstrologyCalculator.getHouseLord(10), PlanetType.saturn);
    });

    test('should return correct lord for house 11 (Aquarius)', () {
      expect(AstrologyCalculator.getHouseLord(11), PlanetType.saturn);
    });

    test('should return correct lord for house 12 (Pisces)', () {
      expect(AstrologyCalculator.getHouseLord(12), PlanetType.jupiter);
    });

    test('should handle house numbers > 12 by wrapping around', () {
      expect(AstrologyCalculator.getHouseLord(13), PlanetType.mars); // 13 is like 1
      expect(AstrologyCalculator.getHouseLord(24), PlanetType.jupiter); // 24 is like 12
    });

    test('should handle zero and negative house numbers', () {
      // (0 - 1) % 12 = -1 % 12 = 11 (Pisces)
      expect(AstrologyCalculator.getHouseLord(0), PlanetType.jupiter);
      // (-1 - 1) % 12 = -2 % 12 = 10 (Aquarius)
      expect(AstrologyCalculator.getHouseLord(-1), PlanetType.saturn);
    });
  });
}
