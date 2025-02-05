import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSettingsPressed;

  const AppHeader({
    super.key,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("solo", textAlign: TextAlign.center),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: onSettingsPressed,
        ),
      ],
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
      appBar: AppHeader(
        onSettingsPressed: () {
          // Handle settings press
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text('Menu'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () => context.go('/'),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Handle settings menu item press
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: const Text('Menu'),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Handle home menu item press
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              // Handle settings menu item press
            },
          ),
        ],
      ),
    );
  }
}
