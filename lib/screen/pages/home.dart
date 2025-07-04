import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/widgets/home.dart';
import 'package:solo/screen/router.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8F9FA),
            Color(0xFFE9ECEF),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Date and Time
              const CurrentDateTime(),
              const SizedBox(height: 24),
              // Today's Todos
              const TodayTodosWidget(),
              const SizedBox(height: 24),
              // Quick Actions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'クイックアクション',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Navigation Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: NavigationCard(
                        title: 'ポモドーロ',
                        subtitle: '集中タイマー',
                        icon: Icons.timer_rounded,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFFE91E63),
                        onTap: () {
                          nextRouting(context, RouterDefinition.timer);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: NavigationCard(
                        title: 'Todo管理',
                        subtitle: 'タスク一覧',
                        icon: Icons.checklist_rounded,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF2196F3),
                        onTap: () {
                          nextRouting(context, RouterDefinition.todoList);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Welcome Message or Tips
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF3E5F5),
                          ),
                          child: const Icon(
                            Icons.lightbulb_rounded,
                            color: Color(0xFF9C27B0),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          '今日も頑張りましょう！',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ポモドーロテクニックで集中し、タスクを効率よく完了させましょう。小さな目標から始めて、継続することが大切です。',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6C757D),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
