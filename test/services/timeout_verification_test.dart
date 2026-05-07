import 'dart:async';
import 'dart:convert';

// Mock Response
class MockResponse {
  final int statusCode;
  final String body;
  MockResponse(this.statusCode, this.body);
}

// Mock Client
class MockClient {
  final Future<MockResponse> Function() handler;
  MockClient(this.handler);
  Future<MockResponse> get() => handler();
}

// Simplified Service with the SAME logic as production
class LocationServiceTestable {
  static Future<void> testRequest(MockClient client, Duration timeout) async {
    await client.get().timeout(timeout);
  }
}

void main() async {
  print('Running timeout verification test...');

  // Test Case: Timeout occurs
  final client = MockClient(() async {
    await Future.delayed(Duration(milliseconds: 500));
    return MockResponse(200, '[]');
  });

  try {
    await LocationServiceTestable.testRequest(client, Duration(milliseconds: 100));
    print('FAILED: Timeout did not occur');
  } catch (e) {
    if (e.toString().contains('TimeoutException')) {
      print('PASSED: Timeout caught as expected: $e');
    } else {
      print('FAILED: Unexpected error: $e');
    }
  }

  // Test Case: Success
  final successClient = MockClient(() async {
    return MockResponse(200, '[]');
  });

  try {
    await LocationServiceTestable.testRequest(successClient, Duration(milliseconds: 100));
    print('PASSED: Success within timeout');
  } catch (e) {
    print('FAILED: Unexpected error: $e');
  }
}
