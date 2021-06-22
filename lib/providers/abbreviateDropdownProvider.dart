import 'package:flutter/material.dart';

class AbbreviateDropdownProvider extends ChangeNotifier {
  bool _abbreviate = true;

  bool get shouldAbbreviate => _abbreviate;

  void abbreviate() {
    _abbreviate = true;
    notifyListeners();
  }

  void dontAbbreviate() {
    _abbreviate = false;
    notifyListeners();
  }
}
