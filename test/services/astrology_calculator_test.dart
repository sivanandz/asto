import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/user_profile.dart';
import 'package:my_app/models/birth_chart.dart';
import 'package:my_app/models/planet_position.dart';
import 'package:my_app/services/astrology_calculator.dart';

void main() {
  group('AstrologyCalculator', () {
    late UserProfile standardUser;

    setUp(() {
      standardUser = UserProfile(
        id: 'test-id',
        name: 'Test User',
        birthDate: DateTime(2000, 1, 1),
        birthTime: '12:00',
        birthLocation: 'London, UK',
        latitude: 51.5074,
        longitude: -0.1278,
      );
    });

    test('calculates western chart correctly', () {
      final chart = AstrologyCalculator.calculateChart(
        standardUser,
        type: ChartType.western,
      );

      expect(chart.userId, equals('test-id'));
      expect(chart.type, equals(ChartType.western));
      expect(chart.positions.length, greaterThan(0));

      // Ascendant
      final ascendant = chart.ascendant;
      expect(ascendant, isNotNull);
      expect(ascendant!.degree, greaterThanOrEqualTo(0.0));
      expect(ascendant.degree, lessThan(360.0));
      expect(ascendant.house, equals(1));

      // Sun
      final sun = chart.sun;
      expect(sun, isNotNull);
      expect(sun!.planet, equals(PlanetType.sun));

      // All planets should have valid degree ranges
      for (final position in chart.positions) {
        expect(position.degree, greaterThanOrEqualTo(0.0));
        expect(position.degree, lessThan(360.0));
        expect(position.house, greaterThanOrEqualTo(1));
        expect(position.house, lessThanOrEqualTo(12));
      }
    });

    test('calculates vedic chart applying ayanamsa', () {
      final westernChart = AstrologyCalculator.calculateChart(
        standardUser,
        type: ChartType.western,
      );

      final vedicChart = AstrologyCalculator.calculateChart(
        standardUser,
        type: ChartType.vedicNorthIndian,
        ayanamsa: AyanamsaType.lahiri,
      );

      // Sun longitude should be different due to Ayanamsa adjustment
      expect(
        vedicChart.sun!.degree,
        isNot(equals(westernChart.sun!.degree)),
      );
    });

    test('handles invalid birth times gracefully', () {
      final userInvalidTime = standardUser.copyWith(birthTime: 'invalid:time');

      final chartInvalidTime = AstrologyCalculator.calculateChart(
        userInvalidTime,
        type: ChartType.western,
      );

      final chartDefaultTime = AstrologyCalculator.calculateChart(
        standardUser, // 12:00 default
        type: ChartType.western,
      );

      // The invalid time falls back to 12:00, so the charts should have identical ascendant
      expect(
        chartInvalidTime.ascendant!.degree,
        closeTo(chartDefaultTime.ascendant!.degree, 0.001),
      );
    });

    test('getHouseLord returns correct planet for house', () {
      expect(AstrologyCalculator.getHouseLord(1), equals(PlanetType.mars));
      expect(AstrologyCalculator.getHouseLord(2), equals(PlanetType.venus));
      expect(AstrologyCalculator.getHouseLord(4), equals(PlanetType.moon));
      expect(AstrologyCalculator.getHouseLord(5), equals(PlanetType.sun));
      expect(AstrologyCalculator.getHouseLord(12), equals(PlanetType.jupiter));

      // Check wrap-around
      expect(AstrologyCalculator.getHouseLord(13), equals(PlanetType.mars));
    });
  });
}
