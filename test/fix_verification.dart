import 'dart:math' as math;

class EntropyRandomStub {
  int nextInt(int max) {
    return math.Random.secure().nextInt(max);
  }

  List<int> nextUniqueInts(int count, int max) {
    if (count > max) {
      throw ArgumentError('Count cannot be greater than max');
    }

    final result = <int>{};
    final random = math.Random.secure();

    while (result.length < count) {
      result.add(random.nextInt(max));
    }

    return result.toList();
  }
}

void main() {
  final entropyRandom = EntropyRandomStub();

  print('Testing nextInt...');
  for (var i = 0; i < 100; i++) {
    final val = entropyRandom.nextInt(10);
    if (val < 0 || val >= 10) {
      throw Exception('nextInt(10) returned out of bounds value: $val');
    }
  }
  print('nextInt passed.');

  print('Testing nextUniqueInts...');
  final uniqueInts = entropyRandom.nextUniqueInts(5, 10);
  print('Generated: $uniqueInts');
  if (uniqueInts.length != 5) {
    throw Exception('nextUniqueInts(5, 10) returned wrong length: ${uniqueInts.length}');
  }
  if (uniqueInts.toSet().length != 5) {
    throw Exception('nextUniqueInts(5, 10) returned non-unique values: $uniqueInts');
  }
  for (final val in uniqueInts) {
    if (val < 0 || val >= 10) {
      throw Exception('nextUniqueInts(5, 10) returned out of bounds value: $val');
    }
  }
  print('nextUniqueInts passed.');

  print('All verification tests passed.');
}
