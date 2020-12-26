import 'package:flutter/material.dart';
import 'package:wru_fe/styles/style.dart' as style;

class DarkTheme {
  static var themeDark = ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.yellow[700]),
    ),
    cardTheme: style.Style.backgroundCardColor,
    accentIconTheme: style.Style.iconTheme,
    backgroundColor: style.Style.backgroundColor,
    buttonColor: style.Style.buttonColor,
    primaryColor: style.Style.textColor,
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      buttonColor: Colors.yellow[900],
      hoverColor: Colors.yellow[700],
    ),
    textTheme: TextTheme(
      button: style.Style.buttonBgColor,
      headline4: style.Style.textBody,
      headline5: style.Style.textHeader,
      headline6: style.Style.textLogo,
    ),
  );
}
