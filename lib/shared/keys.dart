import 'package:flutter/material.dart';

class Keys {
  // Sign in page.
  static const Key signInEmailField = Key('Sign in email field');
  static const Key signInPasswordField = Key('Sign in password field');
  static const Key signInButton = Key('Sign in button');
  static const Key signInRegisterButton = Key('Sign in register button');
  static const Key signInErrorMessage = Key('Sign in error message');

  // Home page.
  static const Key homePageScaffold = Key('Home page scaffold');

  // Register page.
  static const Key registerPageScaffold = Key('Register page scaffold');
  static const Key registerNameField = Key('Regsiter name field');
  static const Key registerEmailField = Key('Register email field');
  static const Key registerPasswordField = Key('Register password field');
  static const Key registerConfirmPasswordField =
      Key('Register confirm password field');
  static const Key registerButton = Key('Register button');
  static const Key registerSignInButton = Key('Register sign in button');
}
