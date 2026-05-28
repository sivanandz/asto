import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:my_app/models/location_model.dart';
import 'package:my_app/services/location_service.dart';

void main() {
  group('LocationService.searchLocations Tests', () {
    tearDown(() {
      LocationService.setHttpClient(null);
    });

    test('returns list of LocationModel on 200 OK', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path == '/search') {
          return http.Response(
            json.encode([
              {
                'place_id': 12345,
                'display_name': 'London, United Kingdom',
                'lat': '51.5074',
                'lon': '-0.1278',
                'address': {
                  'city': 'London',
                  'country': 'United Kingdom'
                }
              }
            ]),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      LocationService.setHttpClient(mockClient);

      final results = await LocationService.searchLocations('London');
      expect(results, isA<List<LocationModel>>());
      expect(results.length, 1);
      expect(results.first.displayName, 'London, United Kingdom');
      expect(results.first.latitude, 51.5074);
      expect(results.first.longitude, -0.1278);
    });

    test('throws exception on non-200 status code', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      LocationService.setHttpClient(mockClient);

      expect(
        () async => await LocationService.searchLocations('London'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to search locations: 500'),
          ),
        ),
      );
    });

    test('throws exception on network error', () async {
      final mockClient = MockClient((request) async {
        throw http.ClientException('Network error');
      });

      LocationService.setHttpClient(mockClient);

      expect(
        () async => await LocationService.searchLocations('London'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Location search error:'),
          ),
        ),
      );
    });

    test('returns empty list for very short queries', () async {
      final results = await LocationService.searchLocations('L');
      expect(results, isEmpty);
    });
  });
}
