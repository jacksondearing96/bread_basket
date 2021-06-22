import 'dart:async';

class WorkoutSetTypeService {
  final _shouldAbbreviateController = StreamController<bool>.broadcast();

  // Auth changed user stream.
  Stream<bool> get shouldAbbreviate {
    return _shouldAbbreviateController.stream;
  }

  void abbreviate() {
    _shouldAbbreviateController.add(true);
  }

  void elongate() {
    _shouldAbbreviateController.add(false);
  }

  void dispose() {
    print('Service has TERMINATED');
    _shouldAbbreviateController.close();
  }
}
