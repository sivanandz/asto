import 'lib/models/birth_chart.dart';
import 'lib/models/planet_position.dart';

void main() {
  final chart = BirthChart(
    userId: 'test_user',
    type: ChartType.vedicNorthIndian,
    positions: [
      PlanetPosition(
        planet: PlanetType.sun,
        sign: ZodiacSign.aries,
        degree: 15.0,
        house: 1,
        isRetrograde: false,
      ),
      PlanetPosition(
        planet: PlanetType.moon,
        sign: ZodiacSign.taurus,
        degree: 10.0,
        house: 2,
        isRetrograde: false,
      ),
      PlanetPosition(
        planet: PlanetType.mars,
        sign: ZodiacSign.aries,
        degree: 20.0,
        house: 1,
        isRetrograde: false,
      ),
    ],
  );

  // Original O(N) lookup approach
  final startOriginal = DateTime.now();
  int totalOriginal = 0;
  for (int i = 0; i < 100000; i++) {
    for (int house = 1; house <= 12; house++) {
      final planets = chart.positions.where((p) => p.house == house).toList();
      totalOriginal += planets.length;
    }
  }
  final endOriginal = DateTime.now();

  // Optimized O(1) lookup approach
  final startOptimized = DateTime.now();
  int totalOptimized = 0;
  for (int i = 0; i < 100000; i++) {
    final Map<int, List<PlanetPosition>> planetsByHouse = {};
    for (final position in chart.positions) {
      planetsByHouse.putIfAbsent(position.house, () => []).add(position);
    }

    for (int house = 1; house <= 12; house++) {
      final planets = planetsByHouse[house] ?? [];
      totalOptimized += planets.length;
    }
  }
  final endOptimized = DateTime.now();

  print('Original approach (total: $totalOriginal) took: ${endOriginal.difference(startOriginal).inMilliseconds}ms');
  print('Optimized approach (total: $totalOptimized) took: ${endOptimized.difference(startOptimized).inMilliseconds}ms');

  if (totalOriginal == totalOptimized) {
    print('SUCCESS: Both approaches yield the same results!');
  } else {
    print('ERROR: Results mismatch');
  }
}
