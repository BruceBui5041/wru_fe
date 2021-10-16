import 'package:flutter/material.dart';

class LightTheme {
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
      dialogTheme: DialogTheme(backgroundColor: Colors.grey[50]),
      // bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.grey[300]),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.blue[100],
        selectedItemColor: _colorMain,
      ),
      textTheme: TextTheme(
        button:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        headline3: TextStyle(
            color: _colorMain, fontSize: 15, fontWeight: FontWeight.bold),
        headline4: TextStyle(
            color: _colorMain, fontSize: 17, fontWeight: FontWeight.bold),
        headline5: TextStyle(
            color: _colorMain, fontSize: 21, fontWeight: FontWeight.bold),
        headline6: TextStyle(
            color: _colorMain, fontSize: 25, fontWeight: FontWeight.bold),
        bodyText1: const TextStyle(fontSize: 11),
        bodyText2: const TextStyle(fontSize: 14),
        subtitle1: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
        subtitle2: const TextStyle(fontSize: 9, fontStyle: FontStyle.italic),
      ),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: _colorMain));
}
