import 'package:bread_basket/screens/authenticate/register.dart';
import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/shared/keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class FakeAuthService extends Fake implements AuthService {
  bool isRegistered = false;

  @override
  Future<dynamic> registerWithEmailAndPassword(
      String email, String password, String name) {
    isRegistered = true;
    return Future.value(1);
  }
}

void main() {
  bool isShowingRegisterPage = true;
  FakeAuthService fakeAuthService = FakeAuthService();

  void toggleView() {
    isShowingRegisterPage = !isShowingRegisterPage;
  }

  testGoldens('Register widget: email and password errors',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1284, 2778);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    await tester.pumpWidget(MaterialApp(
        home: Register(toggleView: toggleView, authService: fakeAuthService)));

    final nameField = find.byKey(Keys.registerNameField);
    final emailField = find.byKey(Keys.registerEmailField);
    final passwordField = find.byKey(Keys.registerPasswordField);
    final confirmPasswordField = find.byKey(Keys.registerConfirmPasswordField);
    final registerButton = find.byKey(Keys.registerButton);
    await screenMatchesGolden(tester, 'goldens/register');
    expect(nameField, findsOneWidget);
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(confirmPasswordField, findsOneWidget);
    expect(registerButton, findsOneWidget);

    await tester.enterText(nameField, 'UsersName');
    await tester.enterText(passwordField, 'validPassword123');
    await tester.enterText(confirmPasswordField, 'validPassword123');
    await tester.enterText(emailField, 'invalid');
    await tester.tap(registerButton);
    await screenMatchesGolden(tester, 'goldens/registerFailedInvalidEmail');

    await tester.enterText(emailField, 'demo@demo.com');
    await tester.enterText(passwordField, 'nonMatchingPassword123');
    await tester.tap(registerButton);
    await screenMatchesGolden(
        tester, 'goldens/registerFailedNonMatchingPasswords');

    await tester.enterText(passwordField, 'validPassword123');
    expect(fakeAuthService.isRegistered, isFalse);
    await tester.tap(registerButton);
    expect(fakeAuthService.isRegistered, isTrue);
  });

  testGoldens('Register widget: toggle to sign in',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1284, 2778);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    await tester.pumpWidget(MaterialApp(
        home: Register(toggleView: toggleView, authService: fakeAuthService)));

    final signInButton = find.byKey(Keys.registerSignInButton);

    expect(isShowingRegisterPage, isTrue);
    await tester.tap(signInButton);
    expect(isShowingRegisterPage, isFalse);
  });
}
