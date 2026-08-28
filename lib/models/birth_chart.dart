import 'package:uuid/uuid.dart';
import 'planet_position.dart';
import 'user_profile.dart';

enum ChartType {
  western,
  vedicNorthIndian,
  vedicSouthIndian,
}

enum AyanamsaType {
  lahiri,
  raman,
  krishnamurti,
}

class BirthChart {
  final String id;
  final String userId;
  final ChartType type;
  final AyanamsaType? ayanamsa;
  final List<PlanetPosition> positions;
  final DateTime calculatedAt;
  final Map<String, dynamic>? additionalData;

  BirthChart({
    String? id,
    required this.userId,
    required this.type,
    this.ayanamsa,
    required this.positions,
    DateTime? calculatedAt,
    this.additionalData,
  })  : id = id ?? const Uuid().v4(),
        calculatedAt = calculatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'ayanamsa': ayanamsa?.name,
      'positions': positions.map((p) => p.toMap()).toList(),
      'calculatedAt': calculatedAt.toIso8601String(),
      'additionalData': additionalData != null ? additionalData.toString() : null,
    };
  }

  factory BirthChart.fromMap(Map<String, dynamic> map) {
    return BirthChart(
      id: map['id'],
      userId: map['userId'],
      type: ChartType.values.byName(map['type']),
      ayanamsa: map['ayanamsa'] != null ? AyanamsaType.values.byName(map['ayanamsa']) : null,
      positions: (map['positions'] as List)
          .map((p) => PlanetPosition.fromMap(p as Map<String, dynamic>))
          .toList(),
      calculatedAt: DateTime.parse(map['calculatedAt']),
      additionalData: map['additionalData'],
    );
  }

  PlanetPosition? getPlanet(PlanetType planet) {
    // ⚡ Bolt: Avoid try-catch for control flow, use firstOrNull instead for better performance
    return positions.where((p) => p.planet == planet).firstOrNull;
  }

  PlanetPosition? get ascendant => getPlanet(PlanetType.ascendant);
  PlanetPosition? get sun => getPlanet(PlanetType.sun);
  PlanetPosition? get moon => getPlanet(PlanetType.moon);

  List<PlanetPosition> get planetsByHouse {
    final sorted = List<PlanetPosition>.from(positions)
      ..sort((a, b) => a.house.compareTo(b.house));
    return sorted;
  }
}