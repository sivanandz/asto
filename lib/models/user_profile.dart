import 'package:uuid/uuid.dart';

class UserProfile {
  final String id;
  final String name;
  final DateTime birthDate;
  final String birthTime;
  final String birthLocation;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    String? id,
    required this.name,
    required this.birthDate,
    required this.birthTime,
    required this.birthLocation,
    this.latitude,
    this.longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'birthTime': birthTime,
      'birthLocation': birthLocation,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      birthDate: DateTime.parse(map['birthDate']),
      birthTime: map['birthTime'],
      birthLocation: map['birthLocation'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  UserProfile copyWith({
    String? name,
    DateTime? birthDate,
    String? birthTime,
    String? birthLocation,
    double? latitude,
    double? longitude,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthLocation: birthLocation ?? this.birthLocation,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
