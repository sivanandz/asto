import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/birth_chart.dart';
import '../../lib/models/planet_position.dart';

void main() {
  group('BirthChart', () {
    final positions = [
      const PlanetPosition(
        planet: PlanetType.sun,
        sign: ZodiacSign.aries,
        degree: 10.5,
        house: 1,
      ),
      const PlanetPosition(
        planet: PlanetType.moon,
        sign: ZodiacSign.taurus,
        degree: 15.0,
        house: 2,
      ),
    ];

    final birthChart = BirthChart(
      userId: 'user123',
      type: ChartType.western,
      positions: positions,
    );

    group('getPlanet', () {
      test('should return PlanetPosition when the planet exists', () {
        final result = birthChart.getPlanet(PlanetType.sun);
        expect(result, isNotNull);
        expect(result?.planet, PlanetType.sun);
        expect(result?.sign, ZodiacSign.aries);
      });

      test('should return null when the planet does not exist', () {
        final result = birthChart.getPlanet(PlanetType.mars);
        expect(result, isNull);
      });
    });
  });
}
