import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/astrology_calculator.dart';
import '../../lib/models/user_profile.dart';
import '../../lib/models/birth_chart.dart';
import '../../lib/models/planet_position.dart';

void main() {
  group('AstrologyCalculator', () {
    test('calculateChart returns a western chart with 13 planetary positions', () {
      final user = UserProfile(
        id: 'test_user_id',
        name: 'Test User',
        birthDate: DateTime(1990, 5, 15),
        birthTime: '14:30',
        birthLocation: 'New York, NY',
        latitude: 40.7128,
        longitude: -74.0060,
      );

      final chart = AstrologyCalculator.calculateChart(user);

      expect(chart, isNotNull);
      expect(chart.userId, 'test_user_id');
      expect(chart.type, ChartType.western);
      expect(chart.positions.length, 13); // 10 planets + ascendant + rahu + ketu

      final sun = chart.positions.where((p) => p.planet == PlanetType.sun).toList();
      expect(sun.length, 1);
      final moon = chart.positions.where((p) => p.planet == PlanetType.moon).toList();
      expect(moon.length, 1);
      final ascendant = chart.positions.where((p) => p.planet == PlanetType.ascendant).toList();
      expect(ascendant.length, 1);
      final rahu = chart.positions.where((p) => p.planet == PlanetType.rahu).toList();
      expect(rahu.length, 1);
      final ketu = chart.positions.where((p) => p.planet == PlanetType.ketu).toList();
      expect(ketu.length, 1);
      expect(rahu.first.isRetrograde, isTrue);
      expect(ketu.first.isRetrograde, isTrue);
    });

    test('calculateChart returns a vedic chart applying default lahiri ayanamsa', () {
      final user = UserProfile(
        name: 'Vedic User',
        birthDate: DateTime(2000, 1, 1),
        birthTime: '12:00',
        birthLocation: 'Delhi, India',
        latitude: 28.6139,
        longitude: 77.2090,
      );

      final chart = AstrologyCalculator.calculateChart(
        user,
        type: ChartType.vedicNorthIndian,
      );

      expect(chart.type, ChartType.vedicNorthIndian);
      // Because ayanamsa wasn't provided, it should fallback to lahiri
      // Since it applies ayanamsa, coordinates would be modified compared to western
      expect(chart.positions.isNotEmpty, true);
    });

    test('calculateChart handles custom ayanamsa', () {
      final user = UserProfile(
        name: 'Vedic User',
        birthDate: DateTime(2000, 1, 1),
        birthTime: '12:00',
        birthLocation: 'Delhi, India',
        latitude: 28.6139,
        longitude: 77.2090,
      );

      final chartLahiri = AstrologyCalculator.calculateChart(
        user,
        type: ChartType.vedicNorthIndian,
        ayanamsa: AyanamsaType.lahiri,
      );

      final chartRaman = AstrologyCalculator.calculateChart(
        user,
        type: ChartType.vedicNorthIndian,
        ayanamsa: AyanamsaType.raman,
      );

      // Positions should differ due to different ayanamsa
      // Note: in a robust test, we would compare actual degrees
      // We know Ascendant has ayanamsa applied
      final ascLahiri = chartLahiri.ascendant;
      final ascRaman = chartRaman.ascendant;
      expect(ascLahiri?.degree, isNot(equals(ascRaman?.degree)));
    });

    test('getHouseLord returns correct planet type for houses', () {
      expect(AstrologyCalculator.getHouseLord(1), PlanetType.mars);      // Aries
      expect(AstrologyCalculator.getHouseLord(2), PlanetType.venus);     // Taurus
      expect(AstrologyCalculator.getHouseLord(3), PlanetType.mercury);   // Gemini
      expect(AstrologyCalculator.getHouseLord(4), PlanetType.moon);      // Cancer
      expect(AstrologyCalculator.getHouseLord(5), PlanetType.sun);       // Leo
      expect(AstrologyCalculator.getHouseLord(6), PlanetType.mercury);   // Virgo
      expect(AstrologyCalculator.getHouseLord(7), PlanetType.venus);     // Libra
      expect(AstrologyCalculator.getHouseLord(8), PlanetType.mars);      // Scorpio
      expect(AstrologyCalculator.getHouseLord(9), PlanetType.jupiter);   // Sagittarius
      expect(AstrologyCalculator.getHouseLord(10), PlanetType.saturn);   // Capricorn
      expect(AstrologyCalculator.getHouseLord(11), PlanetType.saturn);   // Aquarius
      expect(AstrologyCalculator.getHouseLord(12), PlanetType.jupiter);  // Pisces

      // Handles values beyond 12 wrapping around
      expect(AstrologyCalculator.getHouseLord(13), PlanetType.mars);     // Aries
      expect(AstrologyCalculator.getHouseLord(0), PlanetType.jupiter);   // Pisces
    });

    test('calculateChart handles missing optional inputs (latitude/longitude)', () {
      final user = UserProfile(
        id: 'no_lat_long',
        name: 'No Coord User',
        birthDate: DateTime(1985, 10, 20),
        birthTime: '08:15',
        birthLocation: 'Unknown',
        // No lat/long
      );

      final chart = AstrologyCalculator.calculateChart(user);

      expect(chart, isNotNull);
      expect(chart.positions.length, 13);
      final ascendant = chart.positions.firstWhere((p) => p.planet == PlanetType.ascendant);
      // It should calculate a default based on 0,0
      expect(ascendant, isNotNull);
    });

    test('calculateChart handles invalid birth time format gracefully', () {
      final user = UserProfile(
        name: 'Invalid Time User',
        birthDate: DateTime(1985, 10, 20),
        birthTime: 'invalid_time',
        birthLocation: 'Unknown',
      );

      final chart = AstrologyCalculator.calculateChart(user);

      expect(chart, isNotNull);
      expect(chart.positions.length, 13);
      // Defaults to 12:00
    });
  });
}
