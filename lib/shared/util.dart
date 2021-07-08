import 'dart:math';

import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:email_validator/email_validator.dart';

class Util {
  static String? isValidEmail(String? email) {
    return (email == null || !EmailValidator.validate(email))
        ? "Enter a valid email"
        : null;
  }

  static String? isValidPassword(String? password) {
    return (password == null || password.length < 6)
        ? "Enter password at least 6 characters long"
        : null;
  }

  static double bestWeight(List<PerformedSet> sets) {
    return sets.fold(0, (best, set) => max(best, set.weight));
  }

  static double worstWeight(List<PerformedSet> sets) {
    return sets.fold(0, (worst, set) => min(worst, set.weight));
  }

  static double totalVolume(List<PerformedSet> sets) {
    return sets.fold(0, (volume, set) => volume + set.volume());
  }

  static int progressPercentage(Exercise exercise, Function metric,
      List<PerformedSet> prevSets) {
    double prevMetric = metric(prevSets);
    if (prevMetric == 0) return 0;
    double progressRatio = metric(exercise.sets) / metric(prevSets);
    int rounded = ((progressRatio - 1) * 100).round();
    return rounded;
  }

  static String dateToStringKey(DateTime date) {
    return '${date.day.toString()}-${date.month}-${date.year}';
  }

  static String capitalize(String string) {
    return string.isEmpty
        ? string
        : string[0].toUpperCase() + string.substring(1);
  }
}
