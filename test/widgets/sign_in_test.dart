import 'package:bread_basket/models/user.dart';
import 'package:bread_basket/screens/authenticate/signIn.dart';
import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/shared/keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class FakeAuthService extends Fake implements AuthService {
  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) {
    return Future.value(
        User(name: 'DemoUser', userId: 'xO0JDmepQ1RzXdoeFhS4R17nPEn2'));
  }
}

void main() {
  bool signIn = true;
  FakeAuthService fakeAuthService = FakeAuthService();

  void toggleView() {
    signIn = !signIn;
  }

  testGoldens('Sign in widget: email and password errors',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1284, 2778);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    await tester.pumpWidget(MaterialApp(
        home: SignIn(toggleView: toggleView, authService: fakeAuthService)));

    final emailField = find.byKey(Keys.signInEmailField);
    final passwordField = find.byKey(Keys.signInPasswordField);
    final signInButton = find.byKey(Keys.signInButton);
    await screenMatchesGolden(tester, 'goldens/signIn');
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(signInButton, findsOneWidget);

    await tester.enterText(passwordField, 'validPassword123');
    await tester.enterText(emailField, 'invalid');
    await tester.tap(signInButton);
    await screenMatchesGolden(tester, 'goldens/signInFailedInvalidEmail');

    await tester.enterText(emailField, 'demo@demo.com');
    await tester.enterText(passwordField, 'bad');
    await tester.tap(signInButton);
    await screenMatchesGolden(tester, 'goldens/signInFailedInvalidPassword');
  });

  testGoldens('Sign in widget: toggle to register',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1284, 2778);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    await tester.pumpWidget(MaterialApp(
        home: SignIn(toggleView: toggleView, authService: fakeAuthService)));

    final registerButton = find.byKey(Keys.signInRegisterButton);

    expect(signIn, isTrue);
    await tester.tap(registerButton);
    expect(signIn, isFalse);
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
