import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

// TODO: Merge Exercise with PerformedExercise.
class Exercise {
  final String name;
  final String id;
  String _title = 'Unamed Exercise';
  String _subtitle = '';
  List<dynamic> tags = [];
  late Image _image;
  String _imageLocation = '';
  Image? _equipmentTypeIcon;
  String _equipmentTypeIconLocation = '';

  Exercise({required this.id, required this.name, required this.tags}) {
    this._title = makeTitle();

    for (var tag in Constants.equipmentTypes) {
      if (name.contains(tag)) tags.add(tag);
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
    return this.name == other.name;
  }

  void log() {
    print("EXERCISE >> ID: $id, name: $name, tags: $tags");
  }

  String makeTitle() {
    String _title = name;
    if (name.contains('(')) _title = _title.substring(0, _title.indexOf('('));
    return _title.split('_').map((word) => capitalize(word)).join(' ');
  }

  String makeSubtitle() {
    if (!name.contains('(')) return '';
    List<String> subtitleWords =
        name.substring(name.indexOf('(') + 1, name.length - 1).split('_');
    if (subtitleWords.isEmpty) return '';

    if (Constants.equipmentTypes.contains(subtitleWords[0])) {
      subtitleWords.removeAt(0);
    }

    return subtitleWords.map((word) => capitalize(word)).join(' ');
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
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
}
