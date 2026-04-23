import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import '../../lib/services/location_service.dart';
import '../../lib/models/location_model.dart';

class MockHttpClient extends http.BaseClient {
  final Future<http.Response> Function(http.Request request) handler;

  MockHttpClient(this.handler);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await handler(request as http.Request);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
    );
  }
}

void main() {
  group('LocationService.searchLocations', () {
    test('returns empty list for short query', () async {
      final results = await LocationService.searchLocations('a');
      expect(results, isEmpty);
    });

    test('returns parsed locations on 200 OK', () async {
      final mockClient = MockHttpClient((request) async {
        final jsonResponse = [
          {
            'display_name': 'New York City, New York, USA',
            'lat': '40.7128',
            'lon': '-74.0060',
            'address': {
              'city': 'New York City',
              'state': 'New York',
              'country': 'USA'
            }
          }
        ];
        return http.Response(jsonEncode(jsonResponse), 200);
      });

      final results = await LocationService.searchLocations(
        'New York',
        client: mockClient,
      );

      expect(results, isNotEmpty);
      expect(results.first.displayName, 'New York City, New York, USA');
      expect(results.first.latitude, 40.7128);
      expect(results.first.longitude, -74.0060);
    });

    test('throws exception on non-200 HTTP status', () async {
      final mockClient = MockHttpClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      expect(
        () => LocationService.searchLocations('New York', client: mockClient),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to search locations: 500'),
        )),
      );
    });

    test('throws exception on network failure', () async {
      final mockClient = MockHttpClient((request) async {
        throw Exception('SocketException: Failed host lookup');
      });

      expect(
        () => LocationService.searchLocations('New York', client: mockClient),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('SocketException'),
        )),
      );
    });

    test('throws exception on invalid JSON', () async {
      final mockClient = MockHttpClient((request) async {
        return http.Response('invalid json', 200);
      });

      expect(
        () => LocationService.searchLocations('New York', client: mockClient),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('LocationService.getLocationFromCoordinates', () {
    test('returns parsed location on 200 OK with valid result', () async {
      final mockClient = MockHttpClient((request) async {
        final jsonResponse = {
          'display_name': 'Statue of Liberty, New York, USA',
          'lat': '40.6892',
          'lon': '-74.0445',
          'address': {
            'city': 'New York',
            'state': 'New York',
            'country': 'USA'
          }
        };
        return http.Response(jsonEncode(jsonResponse), 200);
      });

      final result = await LocationService.getLocationFromCoordinates(
        40.6892,
        -74.0445,
        client: mockClient,
      );

      expect(result, isNotNull);
      expect(result!.displayName, 'Statue of Liberty, New York, USA');
      expect(result.latitude, 40.6892);
      expect(result.longitude, -74.0445);
    });

    test('returns null when result contains error', () async {
      final mockClient = MockHttpClient((request) async {
        final jsonResponse = {'error': 'Unable to geocode'};
        return http.Response(jsonEncode(jsonResponse), 200);
      });

      final result = await LocationService.getLocationFromCoordinates(
        0.0,
        0.0,
        client: mockClient,
      );

      expect(result, isNull);
    });

    test('returns null on non-200 HTTP status', () async {
      final mockClient = MockHttpClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final result = await LocationService.getLocationFromCoordinates(
        40.6892,
        -74.0445,
        client: mockClient,
      );

      expect(result, isNull);
    });

    test('throws exception on network failure', () async {
      final mockClient = MockHttpClient((request) async {
        throw Exception('SocketException: Failed host lookup');
      });

      expect(
        () => LocationService.getLocationFromCoordinates(
          40.6892,
          -74.0445,
          client: mockClient,
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('SocketException'),
        )),
      );
    });
  });
}
