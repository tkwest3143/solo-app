import 'package:flutter/material.dart';

// Modern color palette inspired by Material Design 3
class AppColors {
  // Primary gradient colors
  static const Color primaryStart = Color(0xFF667eea);
  static const Color primaryEnd = Color(0xFF764ba2);
  
  // Secondary gradient colors
  static const Color secondaryStart = Color(0xFF11998e);
  static const Color secondaryEnd = Color(0xFF38ef7d);
  
  // Accent colors
  static const Color accentOrange = Color(0xFFff7b7b);
  static const Color accentPink = Color(0xFFff9ff3);
  static const Color accentBlue = Color(0xFF54a0ff);
  static const Color accentGreen = Color(0xFF5f27cd);
  
  // Neutral colors
  static const Color backgroundLight = Color(0xFFf8f9fa);
  static const Color surfaceLight = Color(0xFFffffff);
  static const Color onSurfaceLight = Color(0xFF1a1a1a);
  static const Color onSurfaceLightSecondary = Color(0xFF757575);
}

ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.primaryStart,
  brightness: Brightness.light,
  cardColor: AppColors.surfaceLight,
  shadowColor: Colors.black.withOpacity(0.1),
  scaffoldBackgroundColor: AppColors.backgroundLight,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryStart,
    secondary: AppColors.secondaryStart,
    surface: AppColors.surfaceLight,
    background: AppColors.backgroundLight,
    onSurface: AppColors.onSurfaceLight,
    onBackground: AppColors.onSurfaceLight,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.onSurfaceLight,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurfaceLight,
      letterSpacing: -0.25,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurfaceLight,
      letterSpacing: 0,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.onSurfaceLight,
      letterSpacing: 0.15,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.onSurfaceLightSecondary,
      letterSpacing: 0.25,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
    ),
  ),
  cardTheme: CardTheme(
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    shadowColor: Colors.black.withOpacity(0.1),
  ),
);

ThemeData darkThema = ThemeData(
  primaryColor: AppColors.primaryStart,
  brightness: Brightness.dark,
  cardColor: const Color(0xFF2d3748),
  shadowColor: Colors.black.withOpacity(0.3),
  scaffoldBackgroundColor: const Color(0xFF1a202c),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryStart,
    secondary: AppColors.secondaryStart,
    surface: Color(0xFF2d3748),
    background: Color(0xFF1a202c),
    onSurface: Colors.white,
    onBackground: Colors.white,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: -0.25,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      letterSpacing: 0.15,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Color(0xFFa0aec0),
      letterSpacing: 0.25,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
    ),
  ),
  cardTheme: CardTheme(
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    shadowColor: Colors.black.withOpacity(0.3),
  ),
);
