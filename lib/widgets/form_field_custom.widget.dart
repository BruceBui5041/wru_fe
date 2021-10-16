import 'package:flutter/material.dart';

class FormFieldCustomWidget extends StatelessWidget {
  final String? labelText;
  final TextEditingController controller;
  final ValueChanged<String>? onFieldSubmitted;
  final IconData? icon;
  final bool obscureText;
  final TextInputAction textInputAction;

  FormFieldCustomWidget({
    Key? key,
    required this.controller,
    this.onFieldSubmitted,
    this.labelText,
    this.icon,
    this.obscureText = false,
    required this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: theme.textTheme.headline4?.color,
        fontSize: theme.textTheme.bodyText2?.fontSize,
      ),
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        focusColor: Colors.white,
        labelStyle: TextStyle(
          color: theme.textTheme.headline4?.color,
          fontSize: theme.textTheme.bodyText2?.fontSize,
        ),
        suffixIcon: Icon(
          icon,
          color: theme.primaryColor,
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
