import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/services/astrology_calculator.dart';
import 'package:my_app/models/user_profile.dart';
import 'package:my_app/models/birth_chart.dart';
import 'package:my_app/models/planet_position.dart';

void main() {
  group('AstrologyCalculator.calculateChart', () {
    late UserProfile defaultUser;

    setUp(() {
      defaultUser = UserProfile(
        name: 'Test User',
        birthDate: DateTime(1990, 1, 1),
        birthTime: '12:30',
        birthLocation: 'New York, NY',
        latitude: 40.7128,
        longitude: -74.0060,
      );
    });

    test('should return a BirthChart with western type by default', () {
      final chart = AstrologyCalculator.calculateChart(defaultUser);

      expect(chart.userId, defaultUser.id);
      expect(chart.type, ChartType.western);
      expect(chart.positions, isNotEmpty);
    });

    test('should respect the passed ChartType', () {
      final chart = AstrologyCalculator.calculateChart(
        defaultUser,
        type: ChartType.vedicNorthIndian,
      );

      expect(chart.type, ChartType.vedicNorthIndian);
    });

    test('should include all required celestial bodies', () {
      final chart = AstrologyCalculator.calculateChart(defaultUser);

      final planets = chart.positions.map((p) => p.planet).toSet();
      expect(planets.contains(PlanetType.sun), isTrue);
      expect(planets.contains(PlanetType.moon), isTrue);
      expect(planets.contains(PlanetType.mercury), isTrue);
      expect(planets.contains(PlanetType.venus), isTrue);
      expect(planets.contains(PlanetType.mars), isTrue);
      expect(planets.contains(PlanetType.jupiter), isTrue);
      expect(planets.contains(PlanetType.saturn), isTrue);
      expect(planets.contains(PlanetType.uranus), isTrue);
      expect(planets.contains(PlanetType.neptune), isTrue);
      expect(planets.contains(PlanetType.pluto), isTrue);
      expect(planets.contains(PlanetType.ascendant), isTrue);
      expect(planets.contains(PlanetType.rahu), isTrue);
      expect(planets.contains(PlanetType.ketu), isTrue);
    });

    test('should parse valid birth time correctly and not crash', () {
      final user = defaultUser.copyWith(birthTime: '15:45');
      final chart = AstrologyCalculator.calculateChart(user);
      expect(chart.positions, isNotEmpty);
    });

    test('should fallback gracefully on invalid birth time', () {
      final user = defaultUser.copyWith(birthTime: 'invalid:time');
      final chart = AstrologyCalculator.calculateChart(user);
      expect(chart.positions, isNotEmpty);
    });

    test('ascendant property helper works', () {
      final chart = AstrologyCalculator.calculateChart(defaultUser);
      expect(chart.ascendant, isNotNull);
      expect(chart.ascendant!.planet, PlanetType.ascendant);
    });

    test('sun property helper works', () {
      final chart = AstrologyCalculator.calculateChart(defaultUser);
      expect(chart.sun, isNotNull);
      expect(chart.sun!.planet, PlanetType.sun);
    });

    test('moon property helper works', () {
      final chart = AstrologyCalculator.calculateChart(defaultUser);
      expect(chart.moon, isNotNull);
      expect(chart.moon!.planet, PlanetType.moon);
    });
  });
}
