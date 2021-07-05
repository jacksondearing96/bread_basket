
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
}