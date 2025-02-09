import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      color: Colors.white,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color.fromRGBO(0, 0, 255, 0.3), // RGB (синий цвет с 30% прозрачностью)
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
);
