import 'package:flutter/material.dart';

class DarkTheme {
  static Color? _colorMain = Colors.blue[600];

  static var themeLight = ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: _colorMain),
      ),
      cardTheme: CardTheme(color: Colors.blueGrey[700]),
      accentIconTheme: IconThemeData(color: _colorMain),
      backgroundColor: Colors.white,
      buttonColor: _colorMain,
      primaryColor: _colorMain,
      buttonTheme: ButtonThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        buttonColor: _colorMain,
        hoverColor: _colorMain,
      ),
      textTheme: TextTheme(
        button: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        headline3: TextStyle(color: _colorMain, fontSize: 9),
        headline4: TextStyle(color: _colorMain, fontSize: 11),
        headline5: TextStyle(
            color: _colorMain, fontSize: 21, fontWeight: FontWeight.bold),
        headline6: TextStyle(color: _colorMain, fontSize: 30),
      ),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: _colorMain));
}
