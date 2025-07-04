import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MenuPage extends HookConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 80,
            color: Color(0xFF667eea),
          ),
          SizedBox(height: 16),
          Text(
            'メニュー',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'アプリ設定・その他機能（準備中）',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}