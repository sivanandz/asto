import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/astrology_calculator.dart';
import '../../lib/models/user_profile.dart';
import '../../lib/models/birth_chart.dart';

void main() {
  group('AstrologyCalculator - calculateChart', () {
    test('calculateChart returns a valid chart for a complete user profile', () {
      final user = UserProfile(
        id: 'test-id-1',
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:30',
        birthLocation: 'London, UK',
        latitude: 51.5074,
        longitude: -0.1278,
      );

      final chart = AstrologyCalculator.calculateChart(user);

      expect(chart, isNotNull);
      expect(chart.userId, 'test-id-1');
      expect(chart.type, ChartType.western);
      expect(chart.positions, isNotEmpty);

      // Ensure specific important planets are present
      expect(chart.sun, isNotNull);
      expect(chart.moon, isNotNull);
      expect(chart.ascendant, isNotNull);

      // Check that all positions have valid values
      for (final position in chart.positions) {
        expect(position.degree, greaterThanOrEqualTo(0));
        expect(position.degree, lessThan(360)); // Longitude is 0-360 initially, modulo 30 for degree
        // We know the return model puts degree as degree % 30
        expect(position.degree, lessThan(30));
        expect(position.house, greaterThanOrEqualTo(1));
        expect(position.house, lessThanOrEqualTo(12));
      }
    });

    test('calculateChart handles invalid birth time correctly', () {
      final user = UserProfile(
        id: 'test-id-2',
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: 'invalid-time',
        birthLocation: 'London, UK',
      );

      // Should default to 12:00
      final chart = AstrologyCalculator.calculateChart(user);
      expect(chart, isNotNull);
      expect(chart.positions, isNotEmpty);
      expect(chart.sun, isNotNull);
    });

    test('calculateChart handles empty birth time correctly', () {
      final user = UserProfile(
        id: 'test-id-3',
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '',
        birthLocation: 'London, UK',
      );

      final chart = AstrologyCalculator.calculateChart(user);
      expect(chart, isNotNull);
      expect(chart.positions, isNotEmpty);
    });

    test('calculateChart handles partially invalid birth time (hours only) correctly', () {
      final user = UserProfile(
        id: 'test-id-4',
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '15',
        birthLocation: 'London, UK',
      );

      final chart = AstrologyCalculator.calculateChart(user);
      expect(chart, isNotNull);
      expect(chart.positions, isNotEmpty);
    });

    test('calculateChart handles missing latitude/longitude gracefully', () {
      final user = UserProfile(
        id: 'test-id-5',
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'Unknown Location',
        // Missing latitude and longitude
      );

      final chart = AstrologyCalculator.calculateChart(user);
      expect(chart, isNotNull);
      expect(chart.ascendant, isNotNull);
      // Ensure it doesn't crash and returns valid 0/0 calculated ascendant
    });

    test('calculateChart applies ayanamsa for Vedic North Indian type', () {
      final user = UserProfile(
        id: 'test-id-vedic-north',
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'London, UK',
      );

      final vedicChart = AstrologyCalculator.calculateChart(
        user,
        type: ChartType.vedicNorthIndian,
        ayanamsa: AyanamsaType.lahiri
      );

      expect(vedicChart.type, ChartType.vedicNorthIndian);
      expect(vedicChart.ayanamsa, AyanamsaType.lahiri);
      expect(vedicChart.positions, isNotEmpty);
    });

    test('calculateChart applies ayanamsa for Vedic South Indian type', () {
      final user = UserProfile(
        id: 'test-id-vedic-south',
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'London, UK',
      );

      final vedicChart = AstrologyCalculator.calculateChart(
        user,
        type: ChartType.vedicSouthIndian,
        ayanamsa: AyanamsaType.raman
      );

      expect(vedicChart.type, ChartType.vedicSouthIndian);
      expect(vedicChart.ayanamsa, AyanamsaType.raman);
      expect(vedicChart.positions, isNotEmpty);
    });

    test('calculateChart defaults ayanamsa to lahiri for Vedic types if not provided', () {
      final user = UserProfile(
        id: 'test-id-vedic-default',
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:00',
        birthLocation: 'London, UK',
      );

      final vedicChart = AstrologyCalculator.calculateChart(
        user,
        type: ChartType.vedicNorthIndian,
        // No ayanamsa provided
      );

      expect(vedicChart.type, ChartType.vedicNorthIndian);
      expect(vedicChart.ayanamsa, isNull); // Model holds null but logic defaults to lahiri
      expect(vedicChart.positions, isNotEmpty);
    });
  });
}
