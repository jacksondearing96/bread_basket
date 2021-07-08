import 'dart:ffi';

import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Util Tests', () {
    setUp(() {});

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
  });
}
