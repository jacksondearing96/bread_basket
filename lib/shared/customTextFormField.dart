import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final dynamic validator;
  final dynamic onChanged;
  final bool? obscureText;

  CustomTextFormField(
      {this.hint = '', this.validator, this.onChanged, this.obscureText});

  @override
  Widget build(BuildContext context) {
    print(hint);
    return TextFormField(
      style: TextStyle(color: Constants.textColor),
      decoration: Constants.textInputDecoration.copyWith(hintText: hint),
      validator: validator ?? ((_) => null),
      onChanged: onChanged ?? (_) => {},
      obscureText: obscureText ?? false,
    );
  }
}
