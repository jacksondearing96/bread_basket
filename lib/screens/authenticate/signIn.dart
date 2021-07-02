import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/loading.dart';
import 'package:bread_basket/shared/radiantGradientMask.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

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
                        onPressed: () async {
                          _validateFormAndSignIn();
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
                    Text("Don't have an account yet?",
                        style: TextStyle(color: Constants.hintColor)),
                    SizedBox(height: 10),
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
                        onPressed: () => widget.toggleView(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Expanded(child: Container()),
                    RadiantGradientMask(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: SizedBox(
                          width: 190,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageIcon(AssetImage(Constants.dumbbellIcon),
                                    color: Constants.darkIconColor),
                                SizedBox(width: 5),
                                Text(
                                  'See demo account',
                                  style:
                                      TextStyle(color: Constants.darkIconColor),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                ImageIcon(AssetImage(Constants.dumbbellIcon),
                                    color: Constants.darkIconColor),
                              ]),
                        ),
                        onPressed: () {
                          setState(() {
                            email = 'demo@demo.com';
                            password = 'demo123';
                          });

                          _signIn();
                        },
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          );
  }
}
