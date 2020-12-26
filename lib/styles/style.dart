import 'package:flutter/material.dart';

class Style {
  static final Color backgroundColor = Colors.grey[900];
  static final CardTheme backgroundCardColor =
      CardTheme(color: Colors.blueGrey[700]);
  static final IconThemeData iconTheme =
      IconThemeData(color: Colors.yellow[700]);
  static final Color textColor = Colors.yellow[700];
  static final Color buttonColor = Colors.yellow[700];
  static final Color buttonTextColor = Colors.grey[900];
  static final TextStyle buttonBgColor =
      TextStyle(color: buttonTextColor, fontWeight: FontWeight.w700);
  static final textLogo = TextStyle(color: textColor, fontSize: 60);
  static final textBody = TextStyle(color: textColor, fontSize: 16);
  static final inputDecoration =
      InputDecorationTheme(labelStyle: TextStyle(color: textColor));
  static final textHeader =
      TextStyle(color: textColor, fontSize: 30, fontWeight: FontWeight.bold);
}
