import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundPrimary,
  fontFamily: 'Roboto',
  appBarTheme: AppBarTheme(
    color: AppColors.navBar,
    iconTheme: IconThemeData(color: AppColors.textPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  ),
  colorScheme: ColorScheme.dark(
    primary: AppColors.accent,
    background: AppColors.backgroundPrimary,
    onBackground: AppColors.textPrimary,
    secondary: AppColors.backgroundSecondary,
    onSecondary: AppColors.textSecondary,
    surface: AppColors.backgroundTertiary,
    onSurface: AppColors.textPrimary,
  ),
  dividerColor: AppColors.separator,
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textSecondary,
      fontSize: 14,
    ),
    titleLarge: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);
