import 'package:flutter/material.dart';

enum TodoColor {
  blue('ブルー', Colors.blue),
  orange('オレンジ', Colors.orange),
  green('グリーン', Colors.green),
  red('レッド', Colors.red),
  purple('パープル', Colors.purple);

  final String label;
  final Color color;
  const TodoColor(this.label, this.color);

  String get name => toString().split('.').last;
  static Color getColorFromString(String? colorString) {
    if (colorString == null) return TodoColor.blue.color;
    try {
      final todoColor = TodoColor.values.firstWhere(
        (e) => e.name == colorString,
        orElse: () => TodoColor.blue,
      );
      return todoColor.color;
    } catch (_) {
      return TodoColor.blue.color;
    }
  }

  static String getLabelFromString(String? colorString) {
    if (colorString == null) return TodoColor.blue.label;
    try {
      final todoColor = TodoColor.values.firstWhere(
        (e) => e.name == colorString,
        orElse: () => TodoColor.blue,
      );
      return todoColor.label;
    } catch (_) {
      return TodoColor.blue.label;
    }
  }
}
