import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/astrology_calculator.dart';

void main() {
  group('AstrologyCalculator.calculateJulianDay', () {
    // The algorithm uses simplified assumptions and floating point arithmetic.
    // So we use a small delta for comparing the expected Julian Days.
    // These reference dates are common astronomical epochs and standard dates.

    test('calculates Julian Day for J2000 epoch (Jan 1, 2000, 12:00)', () {
      // J2000.0 is exactly JD 2451545.0
      final jd = AstrologyCalculator.calculateJulianDay(2000, 1, 1, 12.0);
      expect(jd, closeTo(2451545.0, 0.0001));
    });

    test('calculates Julian Day for Unix epoch (Jan 1, 1970, 00:00)', () {
      // Unix epoch corresponds to JD 2440587.5
      final jd = AstrologyCalculator.calculateJulianDay(1970, 1, 1, 0.0);
      expect(jd, closeTo(2440587.5, 0.0001));
    });

    test('calculates Julian Day for recent date (Dec 31, 2023, 18:00)', () {
      // JD for 2023-12-31 18:00:00 UT
      // This tests a late month in the year (month > 2 branch)
      final jd = AstrologyCalculator.calculateJulianDay(2023, 12, 31, 18.0);
      expect(jd, closeTo(2460310.25, 0.0001));
    });

    test('handles leap years correctly (Feb 29, 2024, 00:00)', () {
      // JD for 2024-02-29 00:00:00 UT
      final jd = AstrologyCalculator.calculateJulianDay(2024, 2, 29, 0.0);
      expect(jd, closeTo(2460369.5, 0.0001));
    });

    test('calculates correctly for month <= 2 (Feb 1, 2000, 12:00)', () {
      // Tests the `if (month <= 2)` logic specifically
      // JD for 2000-02-01 12:00:00 UT
      final jd = AstrologyCalculator.calculateJulianDay(2000, 2, 1, 12.0);
      expect(jd, closeTo(2451576.0, 0.0001));
    });

    test('handles historical dates accurately (Oct 4, 1957, 19:28)', () {
      // Sputnik launch: Oct 4, 1957 at 19:28:34 UT
      // Using hour = 19 + (28/60) + (34/3600) = 19.47611
      final jd = AstrologyCalculator.calculateJulianDay(1957, 10, 4, 19 + (28/60) + (34/3600));
      expect(jd, closeTo(2436116.3115, 0.0005));
    });
  });
}
