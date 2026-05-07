import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';

class LocationService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';
  static const String _userAgent = 'ObsidianAstro/1.0';

  /// Search for locations by query string
  /// Returns list of matching locations with coordinates
  static Future<List<LocationModel>> searchLocations(
    String query, {
    int limit = 5,
    http.Client? client,
  }) async {
    if (query.trim().length < 2) return [];

    final httpClient = client ?? http.Client();
    try {
      final response = await httpClient.get(
        Uri.parse(
          '$_baseUrl/search?q=${Uri.encodeComponent(query)}&format=json&addressdetails=1&limit=$limit',
        ),
        headers: {
          'User-Agent': _userAgent,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        return results
            .map((json) => LocationModel.fromNominatimJson(json))
            .toList();
      } else {
        throw Exception('Failed to search locations: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Failed to search locations')) {
        rethrow;
      }
      throw Exception('Location search error: $e');
    } finally {
      if (client == null) {
        httpClient.close();
      }
    }
  }

  /// Reverse geocoding - get location name from coordinates
  static Future<LocationModel?> getLocationFromCoordinates(
    double latitude,
    double longitude, {
    http.Client? client,
  }) async {
    final httpClient = client ?? http.Client();
    try {
      final response = await httpClient.get(
        Uri.parse(
          '$_baseUrl/reverse?lat=$latitude&lon=$longitude&format=json&addressdetails=1',
        ),
        headers: {
          'User-Agent': _userAgent,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['error'] == null) {
          return LocationModel.fromNominatimJson(result);
        }
        return null;
      } else {
        throw Exception('Failed to get location from coordinates: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Failed to get location from coordinates')) {
        rethrow;
      }
      throw Exception('Reverse geocoding error: $e');
    } finally {
      if (client == null) {
        httpClient.close();
      }
    }
  }

  /// Get timezone offset for coordinates
  /// Note: This uses a simple approximation. For production, consider using timezone package
  static double getApproximateTimezoneOffset(double longitude) {
    // Rough approximation: 15 degrees = 1 hour
    return (longitude / 15.0).roundToDouble();
  }
}
