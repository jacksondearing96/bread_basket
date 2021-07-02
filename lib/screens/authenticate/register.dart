import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/loading.dart';
import 'package:bread_basket/shared/radiantGradientMask.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;

  String name = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Constants.backgroundColor,
            appBar: Constants.gradientAppBar(
              title: Text('Sign up to GymStats'),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      style: TextStyle(color: Constants.textColor),
                      decoration: Constants.textInputDecoration
                          .copyWith(hintText: 'Firstname'),
                      validator: (val) => (val == null || val.isEmpty)
                          ? "Enter your name"
                          : null,
                      onChanged: (val) {
                        setState(() => name = val.trim());
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      style: TextStyle(color: Constants.textColor),
                      decoration: Constants.textInputDecoration
                          .copyWith(hintText: 'Email'),
                      validator: (val) =>
                          (val == null || !EmailValidator.validate(val))
                              ? "Enter a valid email"
                              : null,
                      onChanged: (val) {
                        setState(() => email = val.trim());
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                        style: TextStyle(color: Constants.textColor),
                        decoration: Constants.textInputDecoration
                            .copyWith(hintText: 'Password'),
                        validator: (val) => (val == null || val.length < 6)
                            ? "Enter password at least 6 characters long"
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val.trim());
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                        style: TextStyle(color: Constants.textColor),
                        decoration: Constants.textInputDecoration
                            .copyWith(hintText: 'Verify password'),
                        validator: (val) => (val == null || val != password)
                            ? "Passwords do not match"
                            : null,
                        obscureText: true),
                    SizedBox(height: 20.0),
                    RadiantGradientMask(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Constants.darkIconColor),
                        ),
                        onPressed: () async {
                          FormState? state = _formKey.currentState;
                          if (state != null && state.validate()) {
                            setState(() => loading = true);
                            dynamic userCredential =
                                await _auth.registerWithEmailAndPassword(
                                    email, password, name);
                            if (userCredential == null) {
                              setState(() {
                                error = 'Could not register new user';
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
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
                    RadiantGradientMask(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: Constants.darkIconColor),
                        ),
                        onPressed: () => widget.toggleView(),
                      ),
                    ),
                    SizedBox(height: 12.0),

                  ],
                ),
              ),
            ),
          );
  }
}
