import 'package:flutter/material.dart';
import 'package:whisp/config/constants/colors.dart';

class AppTheme {
  const AppTheme._();
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
