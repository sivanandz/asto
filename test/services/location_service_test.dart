import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/location_service.dart';

void main() {
  test('getApproximateTimezoneOffset returns correct values', () {
    expect(LocationService.getApproximateTimezoneOffset(15.0), 1.0);
    expect(LocationService.getApproximateTimezoneOffset(-15.0), -1.0);
  });
}
