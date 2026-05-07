import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import '../../lib/services/location_service.dart';
import '../../lib/models/location_model.dart';

void main() {
  group('LocationService.searchLocations', () {
    test('returns empty list for short query', () async {
      final result = await LocationService.searchLocations('a');
      expect(result, isEmpty);
    });

    test('returns locations on successful 200 response', () async {
      final mockResponse = [
        {
          'display_name': 'London, Greater London, England, United Kingdom',
          'lat': '51.5074',
          'lon': '-0.1278',
          'place_id': 12345,
          'address': {
            'city': 'London',
            'state': 'England',
            'country': 'United Kingdom',
          }
        }
      ];

      final client = MockClient((request) async {
        return http.Response(json.encode(mockResponse), 200);
      });

      final result = await LocationService.searchLocations('London', client: client);

      expect(result, hasLength(1));
      expect(result[0].displayName, contains('London'));
      expect(result[0].latitude, 51.5074);
      expect(result[0].longitude, -0.1278);
    });

    test('throws Exception on 500 server error', () async {
      final client = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      expect(
        () => LocationService.searchLocations('London', client: client),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('500'))),
      );
    });

    test('throws Exception on 404 not found', () async {
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      expect(
        () => LocationService.searchLocations('London', client: client),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('404'))),
      );
    });

    test('throws Exception on network failure', () async {
      final client = MockClient((request) async {
        throw http.ClientException('No internet');
      });

      expect(
        () => LocationService.searchLocations('London', client: client),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('No internet'))),
      );
    });

    test('throws Exception on invalid JSON', () async {
      final client = MockClient((request) async {
        return http.Response('invalid json', 200);
      });

      expect(
        () => LocationService.searchLocations('London', client: client),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('FormatException'))),
      );
    });
  });

  group('LocationService.getLocationFromCoordinates', () {
    test('returns LocationModel on successful response', () async {
      final mockResponse = {
        'display_name': 'London, Greater London, England, United Kingdom',
        'lat': '51.5074',
        'lon': '-0.1278',
        'place_id': 12345,
        'address': {
          'city': 'London',
          'state': 'England',
          'country': 'United Kingdom',
        }
      };

      final client = MockClient((request) async {
        return http.Response(json.encode(mockResponse), 200);
      });

      final result = await LocationService.getLocationFromCoordinates(51.5074, -0.1278, client: client);

      expect(result, isNotNull);
      expect(result!.displayName, contains('London'));
    });

    test('returns null when Nominatim returns error but with 200 status', () async {
      final mockResponse = {'error': 'Unable to geocode'};

      final client = MockClient((request) async {
        return http.Response(json.encode(mockResponse), 200);
      });

      final result = await LocationService.getLocationFromCoordinates(0, 0, client: client);

      expect(result, isNull);
    });

    test('throws Exception on 500 error', () async {
        final client = MockClient((request) async {
          return http.Response('Error', 500);
        });

        expect(
          () => LocationService.getLocationFromCoordinates(0, 0, client: client),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('500'))),
        );
    });
  });
}
