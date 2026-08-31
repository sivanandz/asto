import 'dart:convert';
import 'package:flutter/foundation.dart';
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
  }) async {
    if (query.trim().length < 2) return [];

    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search?q=${Uri.encodeComponent(query)}&format=json&addressdetails=1&limit=$limit',
        ),
        headers: {
          'User-Agent': _userAgent,
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        return results
            .map((json) => LocationModel.fromNominatimJson(json))
            .toList();
      } else {
        debugPrint('Location search failed with status: ${response.statusCode}');
        throw Exception('Location search failed. Please try again later.');
      }
    } catch (e) {
      debugPrint('Location search error: $e');
      throw Exception('Location search failed. Please try again later.');
    }
  }

  /// Reverse geocoding - get location name from coordinates
  static Future<LocationModel?> getLocationFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/reverse?lat=$latitude&lon=$longitude&format=json&addressdetails=1',
        ),
        headers: {
          'User-Agent': _userAgent,
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['error'] == null) {
          return LocationModel.fromNominatimJson(result);
        }
      } else {
        debugPrint('Reverse geocoding failed with status: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      debugPrint('Reverse geocoding error: $e');
      throw Exception('Reverse geocoding failed. Please try again later.');
    }
  }

  /// Get timezone offset for coordinates
  /// Note: This uses a simple approximation. For production, consider using timezone package
  static double getApproximateTimezoneOffset(double longitude) {
    // Rough approximation: 15 degrees = 1 hour
    return (longitude / 15.0).roundToDouble();
  }
}