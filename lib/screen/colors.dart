import 'package:flutter/material.dart';

// Custom color definitions for the app
class AppColors {
  // Primary brand colors
  static const Color primaryBlue = Color(0xFF667eea);
  static const Color primaryPurple = Color(0xFF764ba2);
  
  // Text colors
  static const Color primaryText = Color(0xFF2C3E50);
  static const Color secondaryText = Color(0xFF6C757D);
  static const Color mutedText = Color(0xFF9E9E9E);
  static const Color disabledText = Color(0xFFBDBDBD);
  
  // Background colors
  static const Color lightBackgroundStart = Color(0xFFF8F9FA);
  static const Color lightBackgroundEnd = Color(0xFFE9ECEF);
  static const Color darkBackgroundStart = Color(0xFF1A1A1A);
  static const Color darkBackgroundEnd = Color(0xFF2D2D2D);
  
  // Surface colors
  static const Color lightSurface = Colors.white;
  static const Color darkSurface = Color(0xFF3A3A3A);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color darkBorder = Color(0xFF4A4A4A);
  
  // Functional colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successBackground = Color(0xFFE8F5E8);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningBackground = Color(0xFFFFF3E0);
  static const Color error = Colors.red;
  static const Color errorBackground = Color(0xFFFFEBEE);
  
  // Special colors
  static const Color todayTag = primaryBlue;
  static const Color completedTask = success;
  
  // Shadow colors
  static Color lightShadow = Colors.black.withValues(alpha: 0.1);
  static Color mediumShadow = Colors.black.withValues(alpha: 0.2);
  static Color darkShadowLight = Colors.black26;
  static Color darkShadowDark = Colors.black54;
}

// Custom color scheme extension
extension AppColorScheme on ColorScheme {
  // Gradient colors
  List<Color> get primaryGradient => brightness == Brightness.light
      ? [AppColors.primaryBlue, AppColors.primaryPurple]
      : [AppColors.primaryBlue.withValues(alpha: 0.8), AppColors.primaryPurple.withValues(alpha: 0.8)];
  
  List<Color> get backgroundGradient => brightness == Brightness.light
      ? [AppColors.lightBackgroundStart, AppColors.lightBackgroundEnd]
      : [AppColors.darkBackgroundStart, AppColors.darkBackgroundEnd];
  
  // Text colors
  Color get primaryTextColor => brightness == Brightness.light
      ? AppColors.primaryText
      : Colors.white;
  
  Color get secondaryTextColor => brightness == Brightness.light
      ? AppColors.secondaryText
      : Colors.white70;
  
  Color get mutedTextColor => brightness == Brightness.light
      ? AppColors.mutedText
      : Colors.white54;
  
  // Success colors
  Color get successColor => AppColors.success;
  Color get successBackgroundColor => brightness == Brightness.light
      ? AppColors.successBackground
      : AppColors.success.withValues(alpha: 0.2);
  
  // Warning colors
  Color get warningColor => AppColors.warning;
  Color get warningBackgroundColor => brightness == Brightness.light
      ? AppColors.warningBackground
      : AppColors.warning.withValues(alpha: 0.2);
  
  // Error colors
  Color get errorColor => AppColors.error;
  Color get errorBackgroundColor => brightness == Brightness.light
      ? AppColors.errorBackground
      : AppColors.error.withValues(alpha: 0.2);
  
  // Special colors
  Color get todayTagColor => brightness == Brightness.light
      ? AppColors.todayTag
      : AppColors.todayTag.withValues(alpha: 0.8);
  
  Color get todayTagBackgroundColor => brightness == Brightness.light
      ? AppColors.todayTag.withValues(alpha: 0.1)
      : AppColors.todayTag.withValues(alpha: 0.3);
  
  // Shadow colors
  Color get lightShadowColor => brightness == Brightness.light
      ? AppColors.lightShadow
      : AppColors.darkShadowDark;
  
  Color get mediumShadowColor => brightness == Brightness.light
      ? AppColors.mediumShadow
      : AppColors.darkShadowDark;
}

// Light theme definition
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryBlue,
    secondary: AppColors.primaryPurple,
    surface: AppColors.lightSurface,
    surfaceContainerHighest: AppColors.lightBackgroundEnd,
    onSurface: AppColors.primaryText,
    onSurfaceVariant: AppColors.secondaryText,
    outline: AppColors.lightBorder,
  ),
  cardColor: AppColors.lightSurface,
  shadowColor: AppColors.lightShadow,
  dividerColor: AppColors.lightBorder,
);

// Dark theme definition
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryBlue,
    secondary: AppColors.primaryPurple,
    surface: AppColors.darkSurface,
    surfaceContainerHighest: AppColors.darkBackgroundEnd,
    onSurface: Colors.white,
    onSurfaceVariant: Colors.white70,
    outline: AppColors.darkBorder,
  ),
  cardColor: AppColors.darkSurface,
  shadowColor: AppColors.darkShadowDark,
  dividerColor: AppColors.darkBorder,
);
