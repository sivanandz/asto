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
      // SECURITY: Added timeout to prevent resource exhaustion from hanging connections
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
        // SECURITY: Internally log the error but do not leak details in the exception
        debugPrint('Failed to search locations: ${response.statusCode}');
        throw Exception('Failed to search locations');
      }
    } catch (e) {
      // SECURITY: Internally log the error but do not leak details in the exception
      debugPrint('Location search error: $e');
      throw Exception('Location search error occurred');
    }
  }

  /// Reverse geocoding - get location name from coordinates
  static Future<LocationModel?> getLocationFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      // SECURITY: Added timeout to prevent resource exhaustion from hanging connections
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
        // SECURITY: Internally log the error but do not leak details in the exception
        debugPrint('Failed to reverse geocode: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      // SECURITY: Internally log the error but do not leak details in the exception
      debugPrint('Reverse geocoding error: $e');
      throw Exception('Reverse geocoding error occurred');
    }
  }

  /// Get timezone offset for coordinates
  /// Note: This uses a simple approximation. For production, consider using timezone package
  static double getApproximateTimezoneOffset(double longitude) {
    // Rough approximation: 15 degrees = 1 hour
    return (longitude / 15.0).roundToDouble();
  }
}