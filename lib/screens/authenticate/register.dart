import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/customButton.dart';
import 'package:bread_basket/shared/customTextFormField.dart';
import 'package:bread_basket/shared/keys.dart';
import 'package:bread_basket/shared/loading.dart';
import 'package:bread_basket/shared/util.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  final AuthService authService;

  Register({required this.toggleView, required this.authService});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;

  String name = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    String? _isValidName(String? name) {
      return (name == null || name.isEmpty) ? "Enter your name" : null;
    }

    _updateNameFromUserInput(String newName) {
      setState(() => name = newName.trim());
    }

    String? _isValidEmail(String? email) {
      return (email == null || !EmailValidator.validate(email))
          ? "Enter a valid email"
          : null;
    }

    _updateEmailFromUserInput(String newEmail) {
      setState(() => email = newEmail.trim());
    }

    _updatePasswordFromUserInput(String newPassword) {
      setState(() => password = newPassword.trim());
    }

    String? _passwordsMatch(String? reEnteredPassword) {
      return (reEnteredPassword == null || reEnteredPassword != password)
          ? "Passwords do not match"
          : null;
    }

    _register() async {
      FormState? state = _formKey.currentState;
      if (state != null && state.validate()) {
        setState(() => loading = true);
        dynamic userCredential = await widget.authService
            .registerWithEmailAndPassword(email, password, name);
        if (userCredential == null) {
          setState(() {
            error = 'Could not register new user';
            loading = false;
          });
        }
      }
    }

    return loading
        ? Loading()
        : Scaffold(
            key: Keys.registerPageScaffold,
            backgroundColor: Constants.backgroundColor,
            appBar: Constants.gradientAppBar(
              title: Text('Sign up to Monotonic'),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      CustomTextFormField(
                        key: Keys.registerNameField,
                        hint: 'Firstname',
                        validator: _isValidName,
                        onChanged: _updateNameFromUserInput,
                      ),
                      SizedBox(height: 20.0),
                      CustomTextFormField(
                        key: Keys.registerEmailField,
                        hint: 'Email',
                        validator: _isValidEmail,
                        onChanged: _updateEmailFromUserInput,
                      ),
                      SizedBox(height: 20.0),
                      CustomTextFormField(
                        key: Keys.registerPasswordField,
                        hint: 'Password',
                        validator: Util.isValidPassword,
                        onChanged: _updatePasswordFromUserInput,
                        obscureText: true,
                      ),
                      SizedBox(height: 20.0),
                      CustomTextFormField(
                        key: Keys.registerConfirmPasswordField,
                        hint: 'Verify password',
                        validator: _passwordsMatch,
                        obscureText: true,
                      ),
                      SizedBox(height: 20.0),
                      CustomButton(
                        key: Keys.registerButton,
                        text: 'Register',
                        onPressed: _register,
                      ),
                      SizedBox(height: 10),
                      Text(error,
                          style: TextStyle(
                            color: Constants.errorColor,
                            fontSize: 14.0,
                          )),
                      SizedBox(height: 10),
                      Text("Already have an account?",
                          style: TextStyle(color: Constants.hintColor)),
                      SizedBox(height: 10),
                      CustomButton(
                        key: Keys.registerSignInButton,
                        text: 'Sign in',
                        onPressed: () => widget.toggleView(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
