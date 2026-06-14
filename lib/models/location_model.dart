class LocationModel {
  final String displayName;
  final String? city;
  final String? state;
  final String? country;
  final double latitude;
  final double longitude;
  final String? placeId;

  LocationModel({
    required this.displayName,
    this.city,
    this.state,
    this.country,
    required this.latitude,
    required this.longitude,
    this.placeId,
  });

  factory LocationModel.fromNominatimJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>? ?? {};

    return LocationModel(
      displayName: json['display_name'] ?? '',
      city:
          address['city'] ??
          address['town'] ??
          address['village'] ??
          address['municipality'],
      state: address['state'] ?? address['province'] ?? address['region'],
      country: address['country'],
      latitude: double.parse(json['lat'] ?? '0'),
      longitude: double.parse(json['lon'] ?? '0'),
      placeId: json['place_id']?.toString(),
    );
  }

  String get formattedAddress {
    final parts = <String>[];
    if (city != null) parts.add(city!);
    if (state != null) parts.add(state!);
    if (country != null) parts.add(country!);
    return parts.join(', ');
  }

  String get shortName {
    return city ?? displayName.split(',').first.trim();
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      displayName: map['displayName'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      placeId: map['placeId'],
    );
  }
}
