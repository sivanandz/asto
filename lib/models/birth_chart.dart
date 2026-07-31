import 'package:uuid/uuid.dart';
import 'dart:convert';

import 'planet_position.dart';

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
      'positions': jsonEncode(positions.map((p) => p.toMap()).toList()),
      'calculatedAt': calculatedAt.toIso8601String(),
      'additionalData': additionalData != null ? jsonEncode(additionalData) : null,
    };
  }

  factory BirthChart.fromMap(Map<String, dynamic> map) {
    List<dynamic> parsedPositions = [];
    if (map['positions'] is String) {
      parsedPositions = jsonDecode(map['positions']);
    } else if (map['positions'] is List) {
      parsedPositions = map['positions'];
    }

    Map<String, dynamic>? parsedAdditionalData;
    if (map['additionalData'] is String) {
      try {
        parsedAdditionalData = jsonDecode(map['additionalData']);
      } catch (_) {}
    } else if (map['additionalData'] is Map) {
      parsedAdditionalData = map['additionalData'];
    }

    return BirthChart(
      id: map['id'],
      userId: map['userId'],
      type: ChartType.values.byName(map['type']),
      ayanamsa: map['ayanamsa'] != null ? AyanamsaType.values.byName(map['ayanamsa']) : null,
      positions: parsedPositions
          .map((p) => PlanetPosition.fromMap(p as Map<String, dynamic>))
          .toList(),
      calculatedAt: DateTime.parse(map['calculatedAt']),
      additionalData: parsedAdditionalData,
    );
  }

  PlanetPosition? getPlanet(PlanetType planet) {
    try {
      return positions.firstWhere((p) => p.planet == planet);
    } catch (_) {
      return null;
    }
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