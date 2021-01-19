import 'package:flutter/material.dart';

class DarkTheme {
  static Color colorMain = Colors.blue[600];

  static var themeLight = ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: colorMain),
    ),
    cardTheme: CardTheme(color: Colors.blueGrey[700]),
    accentIconTheme: IconThemeData(color: colorMain),
    backgroundColor: Colors.white,
    buttonColor: colorMain,
    primaryColor: colorMain,
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      buttonColor: colorMain,
      hoverColor: colorMain,
    ),
    textTheme: TextTheme(
      button: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      headline4: TextStyle(color: colorMain, fontSize: 16),
      headline5: TextStyle(
          color: colorMain, fontSize: 30, fontWeight: FontWeight.bold),
      headline6: TextStyle(color: colorMain, fontSize: 60),
    ),
  );
}
