import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/customTextFormField.dart';
import 'package:bread_basket/shared/customButton.dart';
import 'package:bread_basket/shared/loading.dart';
import 'package:bread_basket/shared/util.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  _signIn() async {
    setState(() => loading = true);
    dynamic user = await _auth.signInWithEmailAndPassword(email, password);
    if (user == null) {
      setState(() {
        error = 'Could not sign in user';
        loading = false;
      });
    }
  }

  _validateFormAndSignIn() {
    FormState? state = _formKey.currentState;
    if (state != null && state.validate()) {
      _signIn();
    }
  }

  _signInToDemoAccount() {
    setState(() {
      email = 'demo@demo.com';
      password = 'demo123';
    });
    _signIn();
  }

  _updateEmailFromUserInput(String newEmailFromUserInput) {
    setState(() => email = newEmailFromUserInput.trim());
  }

  _updatePasswordFromUserInput(String newPasswordFromUserInput) {
    setState(() => password = newPasswordFromUserInput.trim());
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Constants.backgroundColor,
            appBar: Constants.gradientAppBar(
              title: Text('Sign in to GymStats'),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    CustomTextFormField(
                        hint: 'Email',
                        validator: Util.isValidEmail,
                        onChanged: _updateEmailFromUserInput),
                    SizedBox(height: 20.0),
                    CustomTextFormField(
                      hint: 'Password',
                      validator: Util.isValidPassword,
                      onChanged: _updatePasswordFromUserInput,
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    CustomButton(
                        text: 'Sign in', onPressed: _validateFormAndSignIn),
                    SizedBox(height: 10),
                    Text(error,
                        style: TextStyle(
                          color: Constants.errorColor,
                          fontSize: 14.0,
                        )),
                    SizedBox(height: 10),
                    Text("Don't have an account yet?",
                        style: TextStyle(color: Constants.hintColor)),
                    SizedBox(height: 10),
                    CustomButton(
                      text: 'Register',
                      onPressed: widget.toggleView,
                    ),
                    SizedBox(height: 20.0),
                    Expanded(child: Container()),
                    CustomButton(
                      text: 'See demo account',
                      imageIconLocation: Constants.dumbbellIcon,
                      onPressed: _signInToDemoAccount,
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          );
  }
}
