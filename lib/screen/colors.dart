import 'package:flutter/material.dart';

// Custom color definitions for the app
class _AppColors {
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
  static const Color warningBackground = Color(0xFFF3E5F5);
  static const Color error = Colors.red;
  static const Color errorBackground = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF2196F3);
  static const Color infoBackground = Color(0xFFE3F2FD);
  static const Color accent = Color(0xFFE91E63);
  static const Color accentBackground = Color(0xFFF8BBD9);
  static const Color purple = Color(0xFF9C27B0);
  static const Color purpleBackground = Color(0xFFF3E5F5);

  // Special colors
  static const Color todayTag = primaryBlue;
  static const Color completedTask = success;

  // Shadow colors
  static Color lightShadow = Colors.black.withValues(alpha: 0.1);
  static Color mediumShadow = Colors.black.withValues(alpha: 0.2);
  static Color darkShadowLight = Colors.black26;
  static Color darkShadowDark = Colors.black54;

  // Calendar selected day color
  static const Color calendarSelectedDay = Color(0xFFE3F0FF); // 薄い青
}

// Custom color scheme extension
extension AppColorScheme on ColorScheme {
  // Gradient colors
  List<Color> get primaryGradient => brightness == Brightness.light
      ? [_AppColors.primaryBlue, _AppColors.primaryPurple]
      : [
          _AppColors.primaryBlue.withValues(alpha: 0.8),
          _AppColors.primaryPurple.withValues(alpha: 0.8)
        ];

  List<Color> get backgroundGradient => brightness == Brightness.light
      ? [_AppColors.lightBackgroundStart, _AppColors.lightBackgroundEnd]
      : [_AppColors.darkBackgroundStart, _AppColors.darkBackgroundEnd];

  // Text colors
  Color get primaryTextColor =>
      brightness == Brightness.light ? _AppColors.primaryText : Colors.white;

  Color get secondaryTextColor => brightness == Brightness.light
      ? _AppColors.secondaryText
      : Colors.white70;

  Color get mutedTextColor =>
      brightness == Brightness.light ? _AppColors.mutedText : Colors.white54;

  // Success colors
  Color get successColor => _AppColors.success;
  Color get successBackgroundColor => brightness == Brightness.light
      ? _AppColors.successBackground
      : _AppColors.success.withValues(alpha: 0.2);

  // Warning colors
  Color get warningColor => _AppColors.warning;
  Color get warningBackgroundColor => brightness == Brightness.light
      ? _AppColors.warningBackground
      : _AppColors.warning.withValues(alpha: 0.2);

  // Error colors
  Color get errorColor => _AppColors.error;
  Color get errorBackgroundColor => brightness == Brightness.light
      ? _AppColors.errorBackground
      : _AppColors.error.withValues(alpha: 0.2);

  // Info colors
  Color get infoColor => _AppColors.info;
  Color get infoBackgroundColor => brightness == Brightness.light
      ? _AppColors.infoBackground
      : _AppColors.info.withValues(alpha: 0.2);

  // Accent colors
  Color get accentColor => _AppColors.accent;
  Color get accentBackgroundColor => brightness == Brightness.light
      ? _AppColors.accentBackground
      : _AppColors.accent.withValues(alpha: 0.2);

  // Purple colors
  Color get purpleColor => _AppColors.purple;
  Color get purpleBackgroundColor => brightness == Brightness.light
      ? _AppColors.purpleBackground
      : _AppColors.purple.withValues(alpha: 0.2);

  // Special colors
  Color get todayTagColor => brightness == Brightness.light
      ? _AppColors.todayTag
      : _AppColors.todayTag.withValues(alpha: 0.8);

  Color get todayTagBackgroundColor => brightness == Brightness.light
      ? _AppColors.todayTag.withValues(alpha: 0.1)
      : _AppColors.todayTag.withValues(alpha: 0.3);

  // Shadow colors
  Color get lightShadowColor => brightness == Brightness.light
      ? _AppColors.lightShadow
      : _AppColors.darkShadowDark;

  Color get mediumShadowColor => brightness == Brightness.light
      ? _AppColors.mediumShadow
      : _AppColors.darkShadowDark;

  // Calendar selected day color
  Color get calendarSelectedDayColor => _AppColors.calendarSelectedDay;
}

// Light theme definition
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: _AppColors.primaryBlue,
    secondary: _AppColors.primaryPurple,
    surface: _AppColors.lightSurface,
    surfaceContainerHighest: _AppColors.lightBackgroundEnd,
    onSurface: _AppColors.primaryText,
    onSurfaceVariant: _AppColors.secondaryText,
    outline: _AppColors.lightBorder,
  ),
  cardColor: _AppColors.lightSurface,
  shadowColor: _AppColors.lightShadow,
  dividerColor: _AppColors.lightBorder,
);

// Dark theme definition
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: _AppColors.primaryBlue,
    secondary: _AppColors.primaryPurple,
    surface: _AppColors.darkSurface,
    surfaceContainerHighest: _AppColors.darkBackgroundEnd,
    onSurface: Colors.white,
    onSurfaceVariant: Colors.white70,
    outline: _AppColors.darkBorder,
  ),
  cardColor: _AppColors.darkSurface,
  shadowColor: _AppColors.darkShadowDark,
  dividerColor: _AppColors.darkBorder,
);
