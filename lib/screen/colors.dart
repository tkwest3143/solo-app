import 'package:flutter/material.dart';

// Custom color definitions for the app
class _AppColors {
  // Primary brand colors - パステルブルー/パープル
  static const Color primaryBlue = Color(0xFFB3D9FF); // 淡いパステルブルー
  static const Color primaryPurple = Color(0xFFD6B3FF); // 淡いパステルパープル

  // Text colors - 可読性重視のテキスト色
  static const Color primaryText = Color(0xFF2D3748); // より濃いグレー（可読性向上）
  static const Color secondaryText = Color(0xFF4A5568); // 濃いめのグレー
  static const Color mutedText = Color(0xFF718096); // 中程度のグレー
  static const Color disabledText = Color(0xFFA0AEC0); // 薄めのグレー

  // Background colors - パステル調背景
  static const Color lightBackgroundStart = Color(0xFFFAFCFF); // 極薄ブルー系ホワイト
  static const Color lightBackgroundEnd = Color(0xFFF7FAFC); // 極薄グレー系ホワイト
  static const Color darkBackgroundStart = Color(0xFF2D3A4B); // ダークパステルブルーグレー
  static const Color darkBackgroundEnd = Color(0xFF3A485A); // 深めのパステルグレー

  // Surface colors - 清潔感のある色合い
  static const Color lightSurface = Color(0xFFFFFEFF); // ピュアホワイト
  static const Color darkSurface = Color(0xFF4A5568); // ダークパステルグレー
  static const Color lightBorder = Color(0xFFE6FFFA); // 極薄ミントグリーン
  static const Color darkBorder = Color(0xFF5A6C7D); // パステル調ダークボーダー

  // Functional colors - パステル調機能色
  static const Color success = Color(0xFFAEE5D8); // パステルミントグリーン
  static const Color successBackground = Color(0xFFF0FAF7);
  static const Color warning = Color(0xFFFFD89B); // パステルオレンジ
  static const Color warningBackground = Color(0xFFFFF9E6);
  static const Color error = Color(0xFFFFB3B3); // パステルピンク
  static const Color errorBackground = Color(0xFFFFF5F5);
  static const Color info = Color(0xFFAED9FF); // パステルスカイブルー
  static const Color infoBackground = Color(0xFFF0F8FF);
  static const Color accent = Color(0xFFFFB3E6); // パステルローズピンク
  static const Color accentBackground = Color(0xFFFFF5FC);
  static const Color purple = Color(0xFFD1B3FF); // パステルラベンダー
  static const Color purpleBackground = Color(0xFFF8F5FF);

  // Special colors - パステル調特別色
  static const Color todayTag = Color(0xFFB3D9FF); // パステルブルー（プライマリと統一）
  static const Color completedTask = Color(0xFFAEE5D8); // パステルミントグリーン（成功色と統一）

  // Header and Footer colors - ヘッダー・フッター色
  static const Color lightHeaderFooter = Color(0xFFF1F5F9); // ライトテーマ用グレー
  static const Color darkHeaderFooter = Color(0xFF374151); // ダークテーマ用濃いグレー
  static const Color lightHeaderText = Color(0xFF374151); // ライトテーマ用テキスト色
  static const Color darkHeaderText = Color(0xFFFFFFFF); // ダークテーマ用テキスト色

  // Shadow colors - 優しい影色
  static Color lightShadow = Colors.black.withValues(alpha: 0.06); // より薄く
  static Color mediumShadow = Colors.black.withValues(alpha: 0.12); // より薄く
  static Color darkShadowLight = Colors.black12; // より薄く
  static Color darkShadowDark = Colors.black38; // より薄く

  // Calendar selected day color - パステル調選択色
  static const Color calendarSelectedDay = Color(0xFFE6F3FF); // 極薄パステルブルー
}

// Custom color scheme extension
extension AppColorScheme on ColorScheme {
  // Gradient colors - 控えめなグラデーション
  List<Color> get primaryGradient => brightness == Brightness.light
      ? [
          _AppColors.primaryBlue,
          _AppColors.primaryBlue.withValues(alpha: 0.9)
        ] // 同色系で微細なグラデーション
      : [
          Color(0xFF8BB6D9),
          Color(0xFF8BB6D9).withValues(alpha: 0.85) // より微細なグラデーション
        ];

  List<Color> get backgroundGradient => brightness == Brightness.light
      ? [
          _AppColors.lightBackgroundStart,
          _AppColors.lightBackgroundStart.withValues(alpha: 0.98)
        ] // 極微細なグラデーション
      : [
          _AppColors.darkBackgroundStart,
          _AppColors.darkBackgroundStart.withValues(alpha: 0.95)
        ];

  // Text colors - 可読性重視のテキスト色
  Color get primaryTextColor => brightness == Brightness.light
      ? _AppColors.primaryText
      : Color(0xFFF7FAFC);

  Color get secondaryTextColor => brightness == Brightness.light
      ? _AppColors.secondaryText
      : Color(0xFFE2E8F0);

  Color get mutedTextColor =>
      brightness == Brightness.light ? _AppColors.mutedText : Color(0xFFCBD5E0);

  // Success colors - パステル成功色
  Color get successColor => _AppColors.success;
  Color get successBackgroundColor => brightness == Brightness.light
      ? _AppColors.successBackground
      : Color(0xFF4A5D56); // ダークテーマ用パステルグリーン背景

  // Warning colors - パステル警告色
  Color get warningColor => _AppColors.warning;
  Color get warningBackgroundColor => brightness == Brightness.light
      ? _AppColors.warningBackground
      : Color(0xFF5D5349); // ダークテーマ用パステルオレンジ背景

  // Error colors - パステルエラー色
  Color get errorColor => _AppColors.error;
  Color get errorBackgroundColor => brightness == Brightness.light
      ? _AppColors.errorBackground
      : Color(0xFF5D4A4A); // ダークテーマ用パステルピンク背景

  // Info colors - パステル情報色
  Color get infoColor => _AppColors.info;
  Color get infoBackgroundColor => brightness == Brightness.light
      ? _AppColors.infoBackground
      : Color(0xFF4A5A5D); // ダークテーマ用パステルブルー背景

  // Accent colors - パステルアクセント色
  Color get accentColor => _AppColors.accent;
  Color get accentBackgroundColor => brightness == Brightness.light
      ? _AppColors.accentBackground
      : Color(0xFF5D4A59); // ダークテーマ用パステルピンク背景

  // Purple colors - パステル紫色
  Color get purpleColor => _AppColors.purple;
  Color get purpleBackgroundColor => brightness == Brightness.light
      ? _AppColors.purpleBackground
      : Color(0xFF524A5D); // ダークテーマ用パステルパープル背景

  // Special colors - パステル特別色
  Color get todayTagColor => brightness == Brightness.light
      ? _AppColors.todayTag
      : Color(0xFF8BB6D9); // ダークテーマ用パステルブルー

  Color get todayTagBackgroundColor => brightness == Brightness.light
      ? Color(0xFFF0F8FF) // 極薄パステルブルー背景
      : Color(0xFF4A5A68); // ダークテーマ用背景

  // Shadow colors
  Color get lightShadowColor => brightness == Brightness.light
      ? _AppColors.lightShadow
      : _AppColors.darkShadowDark;

  Color get mediumShadowColor => brightness == Brightness.light
      ? _AppColors.mediumShadow
      : _AppColors.darkShadowDark;

  // Calendar selected day color - パステル選択色
  Color get calendarSelectedDayColor => brightness == Brightness.light
      ? _AppColors.calendarSelectedDay
      : Color(0xFF5A6C7D); // ダークテーマ用パステル選択色

  // Header and Footer colors - ヘッダー・フッター色
  Color get headerFooterColor => brightness == Brightness.light
      ? _AppColors.lightHeaderFooter
      : _AppColors.darkHeaderFooter;

  Color get headerFooterTextColor => brightness == Brightness.light
      ? _AppColors.lightHeaderText
      : _AppColors.darkHeaderText;

  Color get headerFooterIconColor => brightness == Brightness.light
      ? _AppColors.lightHeaderText
      : _AppColors.darkHeaderText;
}

// Light theme definition - 可読性重視のパステル調ライトテーマ
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: _AppColors.primaryBlue,
    secondary: _AppColors.primaryPurple,
    surface: _AppColors.lightSurface,
    surfaceContainerHighest: _AppColors.lightBackgroundEnd,
    onSurface: _AppColors.primaryText, // より濃いテキスト色
    onSurfaceVariant: _AppColors.secondaryText, // より濃いサブテキスト色
    outline: _AppColors.lightBorder,
    tertiary: _AppColors.accent,
    onTertiary: _AppColors.primaryText, // より濃いテキスト色
  ),
  cardColor: _AppColors.lightSurface,
  shadowColor: _AppColors.lightShadow,
  dividerColor: _AppColors.lightBorder,
);

// Dark theme definition - 可読性重視のパステル調ダークテーマ
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF8BB6D9), // ダークテーマ用パステルブルー
    secondary: Color(0xFFB399D9), // ダークテーマ用パステルパープル
    surface: _AppColors.darkSurface,
    surfaceContainerHighest: _AppColors.darkBackgroundEnd,
    onSurface: Color(0xFFF7FAFC), // より明るい白色（可読性向上）
    onSurfaceVariant: Color(0xFFE2E8F0), // より明るいグレー（可読性向上）
    outline: _AppColors.darkBorder,
    tertiary: Color(0xFFD9A3CC), // ダークテーマ用パステルピンク
    onTertiary: Color(0xFFF7FAFC), // より明るい白色
  ),
  cardColor: _AppColors.darkSurface,
  shadowColor: _AppColors.darkShadowDark,
  dividerColor: _AppColors.darkBorder,
);
