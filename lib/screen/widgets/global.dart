import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/screen/states/global.dart';

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
    final user = ref.watch(globalStateProvider);
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
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Solo",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: IconButton(
              icon: const Icon(Icons.person_rounded, color: Colors.white),
              onPressed: onSettingsPressed,
            ),
          ),
        ],
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: IconButton(
            icon: const Icon(Icons.home_rounded, color: Colors.white),
            onPressed: () => nextRouting(context, RouterDefinition.home),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);
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
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
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
            icon: Icon(Icons.list_alt_rounded),
            activeIcon: Icon(Icons.list_alt_rounded, size: 28),
            label: 'リスト',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            activeIcon: Icon(Icons.settings_rounded, size: 28),
            label: '設定',
          ),
        ],
        currentIndex: selectedIndex.value,
        onTap: (index) {
          switch (index) {
            case 0:
              nextRouting(context, RouterDefinition.home);
              break;
            case 1:
              nextRouting(context, RouterDefinition.workList);
              break;
            case 2:
              nextRouting(context, RouterDefinition.root);
              break;
          }
          selectedIndex.value = index;
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
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
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
