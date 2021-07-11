import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/util.dart';
import 'package:flutter/material.dart';

class Exercise {
  final String name;
  final String exerciseId;
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String id = UniqueKey().toString();
  List<PerformedSet> sets = [];
  List<dynamic> tags = [];

  String _title = 'Unamed Exercise';
  String _subtitle = '';
  late Image _image;
  String _imageLocation = '';
  Image? _equipmentTypeIcon;
  String _equipmentTypeIconLocation = '';


  Exercise({required this.exerciseId, required this.name, required this.tags}) {
    this._title = makeTitle();

    for (var tag in Constants.equipmentTypes) {
      if (name.contains(tag) && !tags.contains(tag)) tags.add(tag);
    }
    this._subtitle = makeSubtitle();
    if (Constants.equipmentTypes.contains(this._subtitle.toLowerCase()))
      this._subtitle = '';

    this._imageLocation =
        'resources/exercise_images_transparent_background/${this.name}.png';
    this._image = Image.asset(this._imageLocation);
    this._equipmentTypeIconLocation = findExerciseEquipmentTypeIcon();
  }

  Image? get equipmentTypeIcon => _equipmentTypeIcon;
  String get title => _title;
  String get subtitle => _subtitle;
  Image get image => _image;
  String get imageLocation => _imageLocation;
  String get equipmentTypeIconLocation => _equipmentTypeIconLocation;

  bool equals(Exercise other) {
    if (sets.length != other.sets.length) return false;
    for (int i = 0; i < sets.length; ++i) {
      if (!sets[i].equals(other.sets[i])) return false;
    }
    return this.name == other.name &&
        this.exerciseId == other.exerciseId &&
        this.id == other.id &&
        this.timestamp == other.timestamp &&
        this.tags == other.tags;
  }

  void log() {
    print("EXERCISE >> ID: $exerciseId, name: $name, tags: $tags");
    for (PerformedSet s in sets) s.log();
  }

  String makeTitle() {
    String _title = name;
    if (name.contains('(')) _title = _title.substring(0, _title.indexOf('('));
    return _title
        .split('_')
        .map((word) => Util.capitalize(word))
        .join(' ')
        .trim();
  }

  String makeSubtitle() {
    if (!name.contains('(')) return '';
    List<String> subtitleWords =
        name.substring(name.indexOf('(') + 1, name.length - 1).split('_');
    if (subtitleWords.isEmpty) return '';

    if (Constants.equipmentTypes.contains(subtitleWords[0])) {
      subtitleWords.removeAt(0);
    }

    return subtitleWords.map((word) => Util.capitalize(word)).join(' ');
  }

  String findExerciseEquipmentTypeIcon() {
    for (String equipmentType in Constants.equipmentTypes) {
      if (tags.contains(equipmentType))
        return Constants.equipmentTypeIcons[equipmentType]!;
    }
    return '';
  }

  bool isSearchHit(String query, Set<String> tagQueries) {
    // Check that it is compliant with the tag queries first.
    if (tagQueries.isNotEmpty) {
      for (String tag in tagQueries) {
        if (!tags.contains(tag)) return false;
      }
    }

    // Hit full query.
    query = query.toLowerCase();
    if (name.contains(query)) return true;

    List<String> queryWords = query.split(' ');
    if (queryWords.length > 1) {
      // Hit all query words.
      bool hitAllQueryWords = true;
      for (String word in queryWords) {
        if (!isSearchHit(word, tagQueries)) {
          hitAllQueryWords = false;
          break;
        }
      }
      if (hitAllQueryWords) return true;
    }

    return false;
  }

  static Exercise fromJson(Map<String, Object?> json) {
    Exercise exercise = Exercise(
        exerciseId: json['exerciseId']! as String,
        name: json['name']! as String,
        tags: json['tags']! as List<String>);
    exercise.id = json['id']! as String;
    exercise.timestamp = json['timestamp']! as int;

    Map<dynamic, dynamic> setsJson = json['sets']! as Map<dynamic, dynamic>;
    for (String setId in setsJson.keys) {
      exercise.sets
          .add(PerformedSet.fromJson(setsJson[setId]! as Map<String, Object?>));
    }
    exercise.sets.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return exercise;
  }

  double totalVolume() {
    double totalVolume = 0;
    for (PerformedSet performedSet in sets) {
      totalVolume += performedSet.volume();
    }
    return totalVolume;
  }

  PerformedSet bestSet() {
    double bestWeight = 0;
    PerformedSet bestSet = PerformedSet();
    for (PerformedSet performedSet in sets) {
      if (performedSet.weight > bestWeight) bestSet = performedSet;
    }
    return bestSet;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> exerciseJson = {
      'exerciseId': exerciseId,
      'id': id,
      'timestamp': timestamp,
      'name': name,
      'tags': tags,
      'sets': {}
    };
    for (PerformedSet set in sets) {
      // Skip empty sets.
      if (set.reps != 0) exerciseJson['sets']![set.id] = set.toJson();
    }
    return exerciseJson;
  }
}
