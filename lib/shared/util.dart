import 'dart:math';

import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:collection/collection.dart';

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
    if (sets.isEmpty) return 0;
    return sets.fold(double.maxFinite, (worst, set) => min(worst, set.weight));
  }

  static double totalVolume(List<PerformedSet> sets) {
    return sets.fold(0, (volume, set) => volume + set.volume());
  }

  static int progressPercentage(
      Exercise exercise, Function metric, List<PerformedSet> prevSets) {
    double prevMetric = metric(prevSets);
    if (prevMetric == 0) return 0;
    double progressRatio = metric(exercise.sets) / metric(prevSets);
    int rounded = ((progressRatio - 1) * 100).round();
    rounded = min(rounded, 1000);
    rounded = max(rounded, -1000);
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

  static String? isAValidDouble(String? val) {
    return (val != null && double.tryParse(val) != null) ? null : 'invalid';
  }

  static String? isAValidInteger(String? val) {
    return (val != null && int.tryParse(val) != null) ? null : 'invalid';
  }

  static String removeLastCharThatMatches(String str, String c) {
    return (str[str.length - 1] == c) ? str.substring(0, str.length - 1) : str;
  }

  static String makeTitle(String name) {
    String _title = name;
    if (name.contains('(')) _title = _title.substring(0, _title.indexOf('('));
    return _title
        .split('_')
        .map((word) => Util.capitalize(word))
        .join(' ')
        .trim();
  }

  static String makeSubtitle(String name) {
    if (!name.contains('(')) return '';
    List<String> subtitleWords =
        name.substring(name.indexOf('(') + 1, name.length - 1).split('_');
    if (subtitleWords.isEmpty) return '';

    if (Constants.equipmentTypes.contains(subtitleWords[0])) {
      subtitleWords.removeAt(0);
    }

    return subtitleWords.map((word) => Util.capitalize(word)).join(' ');
  }

  static Function listEquals = const ListEquality().equals;
}
