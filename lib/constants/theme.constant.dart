// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// ThemeData Properties
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.grey[100],
  accentColor: Colors.black,
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.black,
    ),
    bodyText1: TextStyle(
      color: Colors.black87,
    ),
    overline: TextStyle(
      color: Colors.white54,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
    bodyText1: TextStyle(
      color: Colors.white70,
      fontSize: 10,
    ),
    overline: TextStyle(
      color: Colors.black54,
    ),
  ),
);
