import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import '../../lib/services/location_service.dart';

void main() {
  group('LocationService Tests', () {
    test('searchLocations returns list of locations on successful response', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString().contains('/search')) {
          return http.Response(
            json.encode([
              {
                'display_name': 'New York, USA',
                'lat': '40.7128',
                'lon': '-74.0060',
                'place_id': '123',
                'address': {'city': 'New York', 'country': 'USA'}
              }
            ]),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final results = await LocationService.searchLocations(
        'New York',
        client: mockClient,
      );

      expect(results, isNotEmpty);
      expect(results.length, 1);
      expect(results.first.displayName, 'New York, USA');
      expect(results.first.latitude, 40.7128);
      expect(results.first.longitude, -74.0060);
    });

    test('searchLocations returns empty list for query too short', () async {
      final mockClient = MockClient((request) async {
        return http.Response('[]', 200);
      });

      final results = await LocationService.searchLocations('a', client: mockClient);
      expect(results, isEmpty);
    });

    test('searchLocations throws exception on HTTP error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      expect(
        () => LocationService.searchLocations('Paris', client: mockClient),
        throwsException,
      );
    });

    test('getLocationFromCoordinates returns location on successful response', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString().contains('/reverse')) {
          return http.Response(
            json.encode({
              'display_name': 'London, UK',
              'lat': '51.5074',
              'lon': '-0.1278',
              'place_id': '456',
              'address': {'city': 'London', 'country': 'UK'}
            }),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final result = await LocationService.getLocationFromCoordinates(
        51.5074,
        -0.1278,
        client: mockClient,
      );

      expect(result, isNotNull);
      expect(result!.displayName, 'London, UK');
      expect(result.city, 'London');
      expect(result.country, 'UK');
    });

    test('getLocationFromCoordinates returns null on error response from API', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          json.encode({'error': 'Unable to geocode'}),
          200,
        );
      });

      final result = await LocationService.getLocationFromCoordinates(
        0.0,
        0.0,
        client: mockClient,
      );

      expect(result, isNull);
    });

    test('getLocationFromCoordinates returns null on HTTP error (status code not 200 without throw inside block)', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final result = await LocationService.getLocationFromCoordinates(0.0, 0.0, client: mockClient);
      expect(result, isNull);
    });

    test('getLocationFromCoordinates throws exception on network error', () async {
      final mockClient = MockClient((request) async {
        throw Exception('Network error');
      });

      expect(
        () => LocationService.getLocationFromCoordinates(0.0, 0.0, client: mockClient),
        throwsException,
      );
    });

    test('getApproximateTimezoneOffset returns correct approximation', () {
      expect(LocationService.getApproximateTimezoneOffset(0.0), 0.0);
      expect(LocationService.getApproximateTimezoneOffset(15.0), 1.0);
      expect(LocationService.getApproximateTimezoneOffset(-15.0), -1.0);
      expect(LocationService.getApproximateTimezoneOffset(75.0), 5.0);
      expect(LocationService.getApproximateTimezoneOffset(-120.0), -8.0);
    });
  });
}
