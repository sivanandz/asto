import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/entropy_random.dart';

void main() {
  group('EntropyRandom', () {
    late EntropyRandom entropyRandom;

    setUp(() {
      entropyRandom = EntropyRandom();
    });

    test('nextUniqueInts throws ArgumentError when count is greater than max', () {
      expect(
        () => entropyRandom.nextUniqueInts(5, 3),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
