import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/utilities/date.dart';
import 'package:solo/services/todo_service.dart';
import 'package:solo/models/todo_model.dart';
import 'package:solo/screen/router.dart';

class CurrentDateTime extends HookConsumerWidget {
  const CurrentDateTime({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateTime = useState(DateTime.now());

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        dateTime.value = DateTime.now();
      });
      return () => timer.cancel();
    }, const []);

    final formattedDate =
        formatDate(dateTime.value, format: 'yyyy年MM月dd日 (EEE)');
    final formattedTime = formatDate(dateTime.value, format: 'HH:mm:ss');

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).colorScheme.primaryGradient,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.lightShadowColor,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.surface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            formattedTime,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TodayTodosWidget extends HookConsumerWidget {
  const TodayTodosWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<TodoModel>>(
      future: _getTodayTodos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final todayTodos = snapshot.data ?? [];
        final incompleteTodos =
            todayTodos.where((todo) => !todo.isCompleted).toList();

        if (incompleteTodos.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.lightShadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.successBackgroundColor,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.successColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '今日のタスクはありません',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.lightShadowColor,
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Theme.of(context).colorScheme.warningBackgroundColor,
                    ),
                    child: Icon(
                      Icons.today,
                      color: Theme.of(context).colorScheme.warningColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '今日のタスク (${incompleteTodos.length}件)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primaryTextColor,
                    ),
                  ),
                ],
              ),
              if (incompleteTodos.length == 1) ...[
                const SizedBox(height: 12),
                Text(
                  incompleteTodos.first.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondaryTextColor,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    nextRouting(context, RouterDefinition.todoList);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                          Theme.of(context).colorScheme.todayTagBackgroundColor,
                    ),
                    child: Text(
                      'すべてのタスクを見る →',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.todayTagColor,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<List<TodoModel>> _getTodayTodos() async {
    final todoService = TodoService();
    final allTodos = await todoService.getTodo();
    final today = DateTime.now();

    return allTodos.where((todo) {
      final todoDate = todo.dueDate;
      return todoDate.year == today.year &&
          todoDate.month == today.month &&
          todoDate.day == today.day;
    }).toList();
  }
}

class NavigationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const NavigationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.lightShadowColor,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primaryTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentTime extends StatelessWidget {
  const CurrentTime({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedTime = '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    return Text(
      formattedTime,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
