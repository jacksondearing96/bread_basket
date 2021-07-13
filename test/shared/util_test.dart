import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/shared/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Util Tests', () {
    setUp(() {});

    List<PerformedSet> testSets() {
      List<PerformedSet> sets = [];
      sets.add(PerformedSet(weight: 4, reps: 1));
      sets.add(PerformedSet(weight: 9, reps: 2));
      sets.add(PerformedSet(weight: 1, reps: 10));
      sets.add(PerformedSet(weight: 6, reps: 1));
      return sets;
    }

    test('Email validator', () {
      String email = 'jacksondearing96@gmail.com';
      expect(Util.isValidEmail(email), isNull);

      email = 'jacksoindearing96@';
      expect(Util.isValidEmail(email), isNotNull);

      email = '3462346345&%^()@gmail.com';
      expect(Util.isValidEmail(email), isNotNull);
    });

    test('Password validator', () {
      String password = 'myvalidpassword123';
      expect(Util.isValidPassword(password), isNull);

      password = 'short';
      expect(Util.isValidPassword(password), isNotNull);
    });

    test('Best Weight', () {
      expect(Util.bestWeight(testSets()), 9.0);
      expect(Util.bestWeight([]), 0);
    });

    test('Worst weight', () {
      expect(Util.worstWeight(testSets()), 1);
      expect(Util.worstWeight([]), 0);
    });

    test('Total volume', () {
      expect(Util.totalVolume(testSets()), 38);
      expect(Util.totalVolume([]), 0);
    });

    test('Progress percentage', () {
      Exercise exercise = Exercise(exerciseId: "id", name: 'name', tags: []);
      exercise.sets = testSets();
      List<PerformedSet> prevSets = [PerformedSet(weight: 4.5, reps: 10)];

      expect(Util.progressPercentage(exercise, Util.bestWeight, prevSets), 100);
      expect(
          Util.progressPercentage(exercise, Util.totalVolume, prevSets), -16);

      // Check that progress percentage is capped at +1000%.
      exercise.sets[0].weight = 100000000;
      expect(
          Util.progressPercentage(exercise, Util.bestWeight, prevSets), 1000);

      // Check that negative progress is capped at -100%.
      prevSets[0].reps = 1000000000000;
      exercise.sets[0].weight = 1;
      expect(
          Util.progressPercentage(exercise, Util.totalVolume, prevSets), -100);
    });

    test('Date to string key', () {
      expect(Util.dateToStringKey(DateTime(2021, 10, 1)), '1-10-2021');
    });

    test('Capitalize', () {
      expect(Util.capitalize('hello'), 'Hello');
      expect(Util.capitalize(''), '');
    });

    test('Is valid double', () {
      expect(Util.isAValidDouble('1.0'), null);
      expect(Util.isAValidDouble(null), 'invalid');
      expect(Util.isAValidDouble('1.0.0'), 'invalid');
      expect(Util.isAValidDouble('-1353'), null);
    });

    test('Is valid int', () {
      expect(Util.isAValidInteger('1.0'), 'invalid');
      expect(Util.isAValidInteger(null), 'invalid');
      expect(Util.isAValidInteger('1.0.0'), 'invalid');
      expect(Util.isAValidInteger('-1353'), null);
      expect(Util.isAValidInteger('1'), null);
    });

    test('Remove last char if present', () {
      expect(Util.removeLastCharThatMatches('abc', 'c'), 'ab');
      expect(Util.removeLastCharThatMatches('abc', 'b'), 'abc');
    });

    test('Make title', () {
      expect(Util.makeTitle('lat_pulldown_(iso-lateral_machine_under_grip)'),
          'Lat Pulldown');
      expect(Util.makeTitle('bench_press_(barbell)'), 'Bench Press');
    });

    test('Make subtitle', () {
      expect(Util.makeSubtitle('lat_pulldown_(iso-lateral_machine_under_grip)'),
          'Iso-lateral Machine Under Grip');
      expect(Util.makeSubtitle('bench_press_(barbell)'), '');
    });
  });
}
