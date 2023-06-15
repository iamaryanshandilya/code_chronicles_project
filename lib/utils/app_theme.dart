import 'package:flutter/material.dart';
import 'package:code_chronicles/utils/constants.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.kBGColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.kBackButtonColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.kButtonColor,
    ),
  );
}
