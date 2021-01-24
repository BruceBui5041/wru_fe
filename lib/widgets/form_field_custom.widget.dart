import 'package:flutter/material.dart';

class FormFieldCustomWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final ValueChanged<String> onFieldSubmitted;
  final IconData icon;
  bool obscureText = false;
  FormFieldCustomWidget(
      {Key key,
      this.controller,
      this.onFieldSubmitted,
      this.labelText,
      this.icon,
      this.obscureText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).textTheme.headline4.color),
      textInputAction: TextInputAction.done,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        focusColor: Colors.white,
        labelStyle:
            TextStyle(color: Theme.of(context).textTheme.headline4.color),
        suffixIcon: Icon(
          icon,
          color: Theme.of(context).accentIconTheme.color,
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
