import 'package:flutter/material.dart';

class FormFieldCustomWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final ValueChanged<String> onFieldSubmitted;
  final IconData icon;
  final bool obscureText;
  final TextInputAction textInputAction;

  FormFieldCustomWidget({
    Key key,
    @required this.controller,
    this.onFieldSubmitted,
    this.labelText,
    this.icon,
    this.obscureText = false,
    @required this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: Theme.of(context).textTheme.headline4.color,
      ),
      textInputAction: this.textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        focusColor: Colors.white,
        labelStyle: TextStyle(
          color: Theme.of(context).textTheme.headline4.color,
        ),
        suffixIcon: Icon(
          icon,
          color: Theme.of(context).accentIconTheme.color,
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
