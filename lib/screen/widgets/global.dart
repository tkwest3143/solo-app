import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solo/screen/router.dart';

class BulderWidget extends StatelessWidget {
  const BulderWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: child,
    );
  }
}

class UserSelectedWidget extends ConsumerWidget {
  const UserSelectedWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BulderWidget(
      child: GlobalLayout(
        child: child,
      ),
    );
  }
}

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback onSettingsPressed;

  const AppHeader({
    super.key,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
            Color(0xFF667eea),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Solo",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_rounded, color: Colors.white),
              onPressed: onSettingsPressed,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class GlobalLayout extends HookWidget {
  final Widget child;

  const GlobalLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(onSettingsPressed: () {}),
      bottomNavigationBar: FooterMenu(),
      body: child,
    );
  }
}

class FooterMenu extends HookWidget {
  const FooterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    
    // Get current route to set correct tab index
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/':
        selectedIndex.value = 0;
        break;
      case '/calendar':
        selectedIndex.value = 1;
        break;
      case '/timer':
        selectedIndex.value = 2;
        break;
      case '/todo-list':
        selectedIndex.value = 3;
        break;
    }
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withValues(alpha: 0.7),
        selectedFontSize: 12,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            activeIcon: Icon(Icons.home_rounded, size: 28),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            activeIcon: Icon(Icons.calendar_today_rounded, size: 28),
            label: 'カレンダー',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_rounded),
            activeIcon: Icon(Icons.timer_rounded, size: 28),
            label: 'タイマー',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded),
            activeIcon: Icon(Icons.checklist_rounded, size: 28),
            label: 'Todo',
          ),
        ],
        currentIndex: selectedIndex.value,
        onTap: (index) {
          switch (index) {
            case 0:
              nextRouting(context, RouterDefinition.root);
              break;
            case 1:
              nextRouting(context, RouterDefinition.calendar);
              break;
            case 2:
              nextRouting(context, RouterDefinition.timer);
              break;
            case 3:
              nextRouting(context, RouterDefinition.todoList);
              break;
          }
        },
      ),
    );
  }
}

class TimeInputForm extends StatelessWidget {
  final TextEditingController controller;
  final String? label;

  const TimeInputForm({
    super.key,
    this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      ).then((time) {
        if (time != null && context.mounted) {
          controller.text = time.format(context);
        }
      }),
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              suffixIcon: const Icon(
                Icons.access_time_rounded,
                color: Color(0xFF667eea),
              ),
            ),
            controller: controller,
            keyboardType: TextInputType.none,
            readOnly: true,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
