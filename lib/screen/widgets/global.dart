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
    return AppBar(
      title: Text("solo", textAlign: TextAlign.center),
      actions: [
        IconButton(
            icon: const Icon(Icons.person_rounded),
            onPressed: onSettingsPressed),
      ],
      leading: IconButton(
        icon: const Icon(Icons.home),
        onPressed: () => nextRouting(context, RouterDefinition.home),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: Colors.grey,
          height: 2.0,
        ),
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
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(31, 57, 57, 57),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'ホーム',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'リスト',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
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
        child: TextField(
          decoration: label != null ? InputDecoration(labelText: label) : null,
          controller: controller,
          keyboardType: TextInputType.none,
          readOnly: true,
        ),
      ),
    );
  }
}
