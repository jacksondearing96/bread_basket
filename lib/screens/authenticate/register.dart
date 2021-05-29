import 'package:bread_basket/services/auth.dart';
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

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        title: Text('Sign up to Bread Basket'),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign in'),
            onPressed: () {
              widget.toggleView();
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
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
                  validator: (val) => (val == null || val.length < 6)
                      ? "Enter password at least 6 characters long"
                      : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val.trim());
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                  validator: (val) => (val == null || val != password)
                      ? "Passwords do not match"
                      : null,
                  obscureText: true),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  FormState? state = _formKey.currentState;
                  if (state != null && state.validate()) {
                    dynamic user = await _auth.registerWithEmailAndPassword(
                        email, password);
                    if (user == null) {
                      setState(() => error = 'Could not register new user');
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
