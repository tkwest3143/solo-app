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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: Theme.of(context).colorScheme.primaryGradient,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).colorScheme.mediumShadowColor,
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.dashboard_rounded,
                        size: 48,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'メニュー',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primaryTextColor,
                        letterSpacing: 1.0,
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

              const SizedBox(height: 35),

              // Main Navigation Cards
              Column(
                children: [
                      // Primary Features (Todo & Timer) - Highlighted
                      Row(
                        children: [
                          Expanded(
                            child: MenuNavigationCard(
                              title: 'Todo',
                              subtitle: 'タスク管理\n今日の予定を確認',
                              icon: Icons.checklist_rounded,
                              iconColor: Theme.of(context).colorScheme.surface,
                              gradientColors:
                                  Theme.of(context).colorScheme.primaryGradient,
                              onTap: () => nextRouting(
                                  context, RouterDefinition.todoList),
                              isHighlighted: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: MenuNavigationCard(
                              title: 'タイマー',
                              subtitle: '集中時間管理\nポモドーロ技法',
                              icon: Icons.timer_rounded,
                              iconColor: Theme.of(context).colorScheme.surface,
                              gradientColors: [
                                Theme.of(context).colorScheme.accentColor,
                                Theme.of(context)
                                    .colorScheme
                                    .accentBackgroundColor
                              ],
                              onTap: () =>
                                  nextRouting(context, RouterDefinition.timer),
                              isHighlighted: true,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Secondary Features - Vertical Layout
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            // Subtle section divider
                            Container(
                              height: 1,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withValues(alpha: 0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Settings Card
                            SizedBox(
                              width: double.infinity,
                              child: MenuNavigationCard(
                                title: '設定',
                                subtitle: 'アプリ設定・カスタマイズ',
                                icon: Icons.settings_rounded,
                                iconColor:
                                    Theme.of(context).colorScheme.primary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                onTap: () => nextRouting(
                                    context, RouterDefinition.settings),
                                iconSize: 28,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // About Card
                            SizedBox(
                              width: double.infinity,
                              child: MenuNavigationCard(
                                title: 'このアプリについて',
                                subtitle: 'アプリ情報・バージョン・機能',
                                icon: Icons.info_rounded,
                                iconColor:
                                    Theme.of(context).colorScheme.primary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                onTap: () => nextRouting(
                                    context, RouterDefinition.about),
                                iconSize: 28,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // App Version Display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.85),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .lightShadowColor,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.apps_rounded,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Solo v1.0.0',
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }
}
