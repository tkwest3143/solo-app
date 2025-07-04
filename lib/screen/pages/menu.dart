import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/screen/widgets/menu_card.dart';

class MenuPage extends HookConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: Theme.of(context).colorScheme.backgroundGradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: Theme.of(context).colorScheme.primaryGradient,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.mediumShadowColor,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.dashboard_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'メニュー',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primaryTextColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '機能を選択してください',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Main Navigation Cards
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Primary Features (Todo & Timer) - Highlighted
                      Row(
                        children: [
                          Expanded(
                            child: MenuNavigationCard(
                              title: 'Todo',
                              subtitle: 'タスク管理\n今日の予定を確認',
                              icon: Icons.checklist_rounded,
                              iconColor: Colors.white,
                              gradientColors: [
                                const Color(0xFF667eea),
                                const Color(0xFF764ba2),
                              ],
                              onTap: () => nextRouting(context, RouterDefinition.todoList),
                              isHighlighted: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: MenuNavigationCard(
                              title: 'タイマー',
                              subtitle: '集中時間管理\nポモドーロ技法',
                              icon: Icons.timer_rounded,
                              iconColor: Colors.white,
                              gradientColors: [
                                const Color(0xFFff9a9e),
                                const Color(0xFFfecfef),
                              ],
                              onTap: () => nextRouting(context, RouterDefinition.timer),
                              isHighlighted: true,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Secondary Features
                      Row(
                        children: [
                          Expanded(
                            child: MenuNavigationCard(
                              title: '設定',
                              subtitle: 'アプリ設定\nカスタマイズ',
                              icon: Icons.settings_rounded,
                              iconColor: Theme.of(context).colorScheme.primary,
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              onTap: () => nextRouting(context, RouterDefinition.settings),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: MenuNavigationCard(
                              title: 'このアプリについて',
                              subtitle: 'アプリ情報\nバージョン・機能',
                              icon: Icons.info_rounded,
                              iconColor: Theme.of(context).colorScheme.primary,
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              onTap: () => nextRouting(context, RouterDefinition.about),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // App Version Display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.lightShadowColor,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Solo v1.0.0',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondaryTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
