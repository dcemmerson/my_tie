import 'package:flutter/material.dart';

class ThemeManager {
  final bool darkMode;

  ThemeData _themeLight = ThemeData(
    // Define the default brightness and colors.
//    buttonColor: ,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blueGrey[700],
      textTheme: ButtonTextTheme.primary,
    ),
    brightness: Brightness.light,
    primaryColor: Colors.blueGrey[600],
    accentColor: Colors.blueGrey[300],
    disabledColor: Colors.grey[700],

//      appBarTheme: AppBarTheme(iconTheme: IconThemeData(size: AppFonts.h6)),

    // Define the default font family.
    fontFamily: 'Ubuntu',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),

    colorScheme: ColorScheme.light().copyWith(
      primaryVariant: Colors.blueGrey[400],
      primary: Colors.blueGrey[600],
      surface: Colors.grey[300],
      secondary: Colors.blueGrey[300],
    ),
  );

  ThemeData _themeDark = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: Colors.orange,
    accentColor: Colors.orange[800],
    disabledColor: Colors.grey[800],

    // appBarTheme: AppBarTheme(iconTheme: IconThemeData(size: AppFonts.h6)),
    // Define the default font family.
    fontFamily: 'Ubuntu',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
    // colorScheme: ColorScheme.dark().copyWith(surface: Colors.blueGrey[100]),
  );

  // light mode

  // dark mode

  ThemeManager({this.darkMode: false});

  ThemeData get themeData => darkMode ? _themeDark : _themeLight;
}
