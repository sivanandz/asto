import 'dart:core';

class PlanetPosition {
  final String planet;
  final int house;
  PlanetPosition(this.planet, this.house);
}

void main() {
  final List<PlanetPosition> positions = [
    PlanetPosition('sun', 1),
    PlanetPosition('moon', 2),
    PlanetPosition('mercury', 3),
    PlanetPosition('venus', 4),
    PlanetPosition('mars', 5),
    PlanetPosition('jupiter', 6),
    PlanetPosition('saturn', 7),
    PlanetPosition('uranus', 8),
    PlanetPosition('neptune', 9),
    PlanetPosition('pluto', 10),
    PlanetPosition('rahu', 11),
    PlanetPosition('ketu', 12),
    PlanetPosition('ascendant', 1),
  ];

  final iterations = 100000;

  // Baseline: Unoptimized
  final stopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    final housePositions = [
      [12, 1, 2],
      [11, null, 3],
      [10, 9, 8],
      [null, 7, 6],
      [null, 5, 4],
    ];

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        int? houseNum;
        if (row == 0) houseNum = housePositions[0][col];
        else if (row == 1 && col == 0) houseNum = housePositions[1][0];
        else if (row == 1 && col == 2) houseNum = housePositions[1][2];
        else if (row == 2) houseNum = housePositions[2][col];

        if (houseNum == null) continue;
        final actualHouse = houseNum;

        final planets = positions.where((p) => p.house == actualHouse).toList();
      }
    }
  }
  stopwatch.stop();
  final baselineTime = stopwatch.elapsedMicroseconds;
  print('Baseline Execution Time ($iterations iterations): $baselineTime microseconds');

  // Optimized: Grouping first
  stopwatch.reset();
  stopwatch.start();
  for (var i = 0; i < iterations; i++) {
    final housePositions = [
      [12, 1, 2],
      [11, null, 3],
      [10, 9, 8],
      [null, 7, 6],
      [null, 5, 4],
    ];

    // Grouping logic (using array for faster mapping since houses are 1-12)
    final List<List<PlanetPosition>> planetsByHouse = List.generate(13, (_) => []);
    for (final p in positions) {
      planetsByHouse[p.house].add(p);
    }

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        int? houseNum;
        if (row == 0) houseNum = housePositions[0][col];
        else if (row == 1 && col == 0) houseNum = housePositions[1][0];
        else if (row == 1 && col == 2) houseNum = housePositions[1][2];
        else if (row == 2) houseNum = housePositions[2][col];

        if (houseNum == null) continue;
        final actualHouse = houseNum;

        final planets = planetsByHouse[actualHouse];
      }
    }
  }
  stopwatch.stop();
  final optimizedTime = stopwatch.elapsedMicroseconds;
  print('Optimized List Execution Time ($iterations iterations): $optimizedTime microseconds');
  print('Improvement: ${(1 - optimizedTime / baselineTime) * 100}%');
}
