import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../lib/services/location_service.dart';

void main() {
  group('LocationService.searchLocations', () {
    test('returns empty list for query shorter than 2 characters', () async {
      final results = await LocationService.searchLocations('a');
      expect(results, isEmpty);
    });

    test('returns list of locations on successful search (200 OK)', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/search')) {
          final jsonResponse = [
            {
              'name': 'Paris',
              'display_name': 'Paris, Ile-de-France, France',
              'lat': '48.8566',
              'lon': '2.3522',
              'address': {
                'city': 'Paris',
                'country': 'France',
                'country_code': 'fr'
              }
            }
          ];
          return http.Response(json.encode(jsonResponse), 200);
        }
        return http.Response('Not Found', 404);
      });

      final results = await LocationService.searchLocations('Paris', client: mockClient);

      expect(results, isNotEmpty);
      expect(results.length, 1);
      expect(results.first.displayName, 'Paris, Ile-de-France, France');
      expect(results.first.city, 'Paris');
      expect(results.first.latitude, 48.8566);
      expect(results.first.longitude, 2.3522);
    });

    test('throws Exception on server error (non-200 OK)', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      expect(
        () => LocationService.searchLocations('London', client: mockClient),
        throwsA(isA<Exception>().having(
            (e) => e.toString(), 'message', contains('Failed to search locations: 500'))),
      );
    });

    test('throws Exception on network error', () async {
      final mockClient = MockClient((request) async {
        throw http.ClientException('Connection failed');
      });

      expect(
        () => LocationService.searchLocations('Berlin', client: mockClient),
        throwsA(isA<Exception>().having(
            (e) => e.toString(), 'message', contains('Location search error:'))),
      );
    });
  });

  group('LocationService.getLocationFromCoordinates', () {
    test('returns LocationModel on successful reverse geocoding (200 OK)', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/reverse')) {
          final jsonResponse = {
            'place_id': 12345,
            'name': 'London',
            'display_name': 'London, Greater London, England, United Kingdom',
            'lat': '51.5074',
            'lon': '-0.1278',
            'address': {
              'city': 'London',
              'state': 'Greater London',
              'country': 'United Kingdom',
              'country_code': 'gb'
            }
          };
          return http.Response(json.encode(jsonResponse), 200);
        }
        return http.Response('Not Found', 404);
      });

      final result = await LocationService.getLocationFromCoordinates(51.5074, -0.1278, client: mockClient);

      expect(result, isNotNull);
      expect(result!.displayName, 'London, Greater London, England, United Kingdom');
      expect(result.city, 'London');
      expect(result.latitude, 51.5074);
      expect(result.longitude, -0.1278);
    });

    test('returns null when API returns an error message in response (200 OK)', () async {
      final mockClient = MockClient((request) async {
        final jsonResponse = {
          'error': 'Unable to geocode'
        };
        return http.Response(json.encode(jsonResponse), 200);
      });

      final result = await LocationService.getLocationFromCoordinates(0, 0, client: mockClient);

      expect(result, isNull);
    });

    test('returns null on server error (non-200 OK)', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final result = await LocationService.getLocationFromCoordinates(51.5074, -0.1278, client: mockClient);

      expect(result, isNull);
    });

    test('throws Exception on network error', () async {
      final mockClient = MockClient((request) async {
        throw http.ClientException('Connection failed');
      });

      expect(
        () => LocationService.getLocationFromCoordinates(51.5074, -0.1278, client: mockClient),
        throwsA(isA<Exception>().having(
            (e) => e.toString(), 'message', contains('Reverse geocoding error:'))),
      );
    });
  });
}
