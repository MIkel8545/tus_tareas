import 'package:flutter/material.dart';

Color color = Colors.green;

final miTema = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(elevation: 0, color: Colors.black),
    primaryColor: color,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.indigo));
