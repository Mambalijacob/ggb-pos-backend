import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(elevation: 2, centerTitle: true),
  );
}
