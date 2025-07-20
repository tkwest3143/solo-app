import 'package:flutter/material.dart';

// Light theme definition - 可読性重視のパステル調ライトテーマ
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: 'NotoSansJP',
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 71, 161, 250), // 濃いめのブルー（可読性重視）
    secondary: Color.fromARGB(255, 208, 251, 243), // 薄ミントグリーン
    surface: Color(0xFFFFFEFF), // ピュアホワイト
    surfaceContainerHighest: Color(0xFFF7FAFC), // 極薄グレー系ホワイト
    onSurface: Color(0xFF2D3748), // より濃いテキスト色
    onSurfaceVariant: Color(0xFF374151), // サブテキスト色をより濃いグレーに
    outline: Color(0xFF7DD6C0), // ミントグリーンを濃く
    tertiary: Color.fromARGB(255, 255, 151, 220), // パステルローズピンク
    onTertiary: Color(0xFF2D3748), // より濃いテキスト色
  ),
  cardColor: const Color(0xFFFFFEFF),
  shadowColor: Colors.black12,
  dividerColor: const Color(0xFFE6FFFA),
);

// Dark theme definition - 可読性重視のパステル調ダークテーマ
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: 'NotoSansJP',
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF8BB6D9), // ダークテーマ用パステルブルー
    secondary: Color.fromARGB(255, 120, 210, 190), // ダークでも見やすいミントグリーン
    surface: Color(0xFF4A5568), // ダークパステルグレー
    surfaceContainerHighest: Color(0xFF3A485A), // 深めのパステルグレー
    onSurface: Color(0xFFF7FAFC), // より明るい白色（可読性向上）
    onSurfaceVariant: Color(0xFFE2E8F0), // より明るいグレー（可読性向上）
    outline: Color(0xFF5A6C7D), // パステル調ダークボーダー
    tertiary: Color(0xFFD9A3CC), // ダークテーマ用パステルピンク
    onTertiary: Color(0xFFF7FAFC), // より明るい白色
  ),
  cardColor: const Color(0xFF4A5568),
  shadowColor: Colors.black38,
  dividerColor: const Color(0xFF5A6C7D),
);

// Custom color scheme extension
extension AppColorScheme on ColorScheme {
  List<Color> get primaryGradient => brightness == Brightness.light
      ? [
          const Color.fromARGB(255, 71, 161, 250),
          const Color.fromARGB(255, 71, 161, 250).withValues(alpha: 0.9)
        ]
      : [
          const Color(0xFF8BB6D9),
          const Color(0xFF8BB6D9).withValues(alpha: 0.85)
        ];

  List<Color> get backgroundGradient => brightness == Brightness.light
      ? [
          const Color(0xFFFAFCFF),
          const Color(0xFFFAFCFF).withValues(alpha: 0.98)
        ]
      : [
          const Color(0xFF2D3A4B),
          const Color(0xFF2D3A4B).withValues(alpha: 0.95)
        ];

  Color get primaryTextColor => brightness == Brightness.light
      ? const Color(0xFF2D3748)
      : const Color(0xFFF7FAFC);

  Color get secondaryTextColor => brightness == Brightness.light
      ? const Color(0xFF374151) // 濃いグレー
      : const Color(0xFFE2E8F0);

  Color get mutedTextColor => brightness == Brightness.light
      ? const Color(0xFF525C6B) // さらに濃いグレー
      : const Color(0xFFCBD5E0);

  Color get successColor => const Color.fromARGB(255, 1, 255, 187);
  Color get successBackgroundColor => brightness == Brightness.light
      ? const Color.fromARGB(255, 218, 247, 238)
      : const Color(0xFF4A5D56);

  Color get warningColor => const Color.fromARGB(255, 255, 177, 53);
  Color get warningBackgroundColor => brightness == Brightness.light
      ? const Color(0xFFFFF9E6)
      : const Color(0xFF5D5349);

  Color get errorColor => const Color.fromARGB(255, 237, 88, 88);
  Color get errorBackgroundColor => brightness == Brightness.light
      ? const Color(0xFFFFF5F5)
      : const Color(0xFF5D4A4A);

  Color get infoColor => const Color.fromARGB(255, 50, 159, 255);
  Color get infoBackgroundColor => brightness == Brightness.light
      ? const Color.fromARGB(255, 202, 221, 241) // 濃いめブルー背景
      : const Color(0xFF4A5A5D);

  Color get accentColor => const Color.fromARGB(255, 245, 72, 187);
  Color get accentBackgroundColor => brightness == Brightness.light
      ? const Color.fromARGB(255, 242, 214, 234) // 濃いめピンク背景
      : const Color(0xFF5D4A59);

  Color get purpleColor => const Color.fromARGB(255, 183, 139, 249);
  Color get purpleBackgroundColor => brightness == Brightness.light
      ? const Color.fromARGB(255, 222, 207, 241) // 濃いめパープル背景
      : const Color(0xFF524A5D);

  Color get todayTagColor => brightness == Brightness.light
      ? const Color(0xFFB3D9FF)
      : const Color(0xFF8BB6D9);

  Color get todayTagBackgroundColor => brightness == Brightness.light
      ? const Color(0xFFF0F8FF)
      : const Color(0xFF4A5A68);

  Color get lightShadowColor => brightness == Brightness.light
      ? Colors.black.withValues(alpha: 0.06)
      : Colors.black38;

  Color get mediumShadowColor => brightness == Brightness.light
      ? Colors.black.withValues(alpha: 0.12)
      : Colors.black38;

  Color get calendarSelectedDayColor => brightness == Brightness.light
      ? const Color(0xFFE6F3FF)
      : const Color(0xFF5A6C7D);

  Color get headerFooterColor => brightness == Brightness.light
      ? const Color(0xFFF1F5F9)
      : const Color(0xFF374151);

  Color get headerFooterTextColor => brightness == Brightness.light
      ? const Color(0xFF374151)
      : const Color(0xFFFFFFFF);

  Color get headerFooterIconColor => brightness == Brightness.light
      ? const Color(0xFF374151)
      : const Color(0xFFFFFFFF);
}
