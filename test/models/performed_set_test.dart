import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Performed Set Tests', () {
    late PerformedSet performedSet;
    const double testWeight = 7.0;
    const int testReps = 8;

    setUp(() {
      performedSet = PerformedSet();
      performedSet.weight = testWeight;
      performedSet.reps = testReps;
    });

    test('Initialisation', () {
      PerformedSet initialisedSet = PerformedSet();
      expect(initialisedSet.setType, Constants.normalCode);
      expect(initialisedSet.reps, 0);
      expect(initialisedSet.weight, 0.0);
    });

    test('Get weight string', () {
      expect(performedSet.getWeightString(), '7');

      performedSet.weight = 10.1;
      expect(performedSet.getWeightString(), '10.1');
    });

    test('Volume', () {
      expect(performedSet.volume(), 56.0);
    });

    test('ToJson', () {
      expect(performedSet.toJson(), {
        'type': Constants.normalCode,
        'weight': testWeight,
        'reps': testReps
      });
    });
  });
}
