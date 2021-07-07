import 'package:bread_basket/screens/authenticate/signIn.dart';
import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/shared/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class FakeAuthService extends Fake implements AuthService {
  @override
  Future signInWithEmailAndPassword(String email, String password) {
    return Future.value(1);
  }
}

void main() {
  bool signIn = true;
  FakeAuthService fakeAuthService = FakeAuthService();

  void toggleView() {
    signIn = !signIn;
  }

  testWidgets('Sign in widget: email input text field',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SignIn(toggleView: toggleView, authService: fakeAuthService)));

    final emailField = find.byKey(Keys.signInEmailField);
    final passwordField = find.byKey(Keys.signInPasswordField);
    final signInButton = find.byKey(Keys.signInButton);
    var errorMessage = find.byKey(Keys.signInErrorMessage);
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(signInButton, findsOneWidget);
    expect(errorMessage, findsNothing);
    tester.enterText(passwordField, 'validPassword123');

    tester.enterText(emailField, 'invalid');
    tester.tap(signInButton);
  });

  // testWidgets('Sign in widget: password input text fields',
  //   //   (WidgetTester tester) async {
  //   // await tester.pumpWidget(MaterialApp(
  //   //     home: SignIn(toggleView: toggleView, authService: fakeAuthService)));

  //   // final passwordField = find.byKey(Keys.signInPasswordField);
  //   // expect(passwordField, findsOneWidget);

  //   // tester.enterText(passwordField, 'invalid');
  // });
}
