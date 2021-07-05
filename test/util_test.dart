import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Performed Set Tests', () {
    setUp(() {});

    test('Email validator', () {
      String email = 'jacksondearing96@gmail.com';
      expect(Util.isValidEmail(email), isTrue);

      email = 'jacksoindearing96@';
      expect(Util.isValidEmail(email), isFalse);

      email = '3462346345&%^()@gmail.com';
      expect(Util.isValidEmail(email), isFalse);
    });

    test('Password validator', () {
      String password = 'myvalidpassword123';
      expect(Util.isValidPassword(password), isTrue);

      password = 'short';
      expect(Util.isValidPassword(password), isFalse);
    });
  });
}
