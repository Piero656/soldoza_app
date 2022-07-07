

import 'package:flutter/material.dart';

class AppTheme {
  
  static const Color primary = Colors.indigo;

  static const Color orangeColor = Color.fromARGB(255, 255, 115, 6);

  static final ThemeData lightTheme = ThemeData.light().copyWith(

    primaryColor: primary,

    appBarTheme: const AppBarTheme(color: orangeColor, elevation: 5)



  );

}