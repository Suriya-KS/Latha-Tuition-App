import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeMode themeMode = ThemeMode.system;

  static ThemeData theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ),
    fontFamily: 'Poppins',
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkSeedColor,
      brightness: Brightness.dark,
    ),
    fontFamily: 'Poppins',
  );
}
