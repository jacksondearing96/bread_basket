import 'dart:async';
import 'dart:io';

import 'package:bread_basket/shared/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file),
        onDone: () {
          completer.complete(files);
        },
        onError: (e) => print('ERROR'));
    return completer.future;
  }

  group('Database Tests', () {
    test('Exercise list and filename consistency', () async {
      // await Firebase.initializeApp();
      Directory dir =
          Directory('resources/exercise_images_transparent_background');
      List<FileSystemEntity> fileSystemEntities =
          await dirContents(dir);
      List<String> filenames = fileSystemEntities
          .map((fileSystemEntity) => fileSystemEntity.path.replaceAll('resources/exercise_images_transparent_background/', ''))
          .toList();
      filenames.forEach((filename) => print(filename));

      Map<String, List<String>> exerciseList = Constants.exerciseList;

      filenames.removeWhere((filename) => filename == '.DS_Store');

      Set<String> ids = {};

      for (String filename in filenames) {
        String trimmedExerciseName = filename.replaceAll('.png', '');

        // Check this filename is in the list.
        print(trimmedExerciseName);
        assert(exerciseList.containsKey(trimmedExerciseName));

        // Check that this exercise has a unique ID.
        String id = exerciseList[trimmedExerciseName]![0];
        assert(!ids.contains(id));
        ids.add(id);
      }

      assert(filenames.length == exerciseList.length);
    });

  });
}
