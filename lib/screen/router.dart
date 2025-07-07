import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/pages/home.dart';
import 'package:solo/screen/pages/calendar.dart';
import 'package:solo/screen/pages/timer.dart';
import 'package:solo/screen/pages/menu.dart';
import 'package:solo/screen/pages/todo_list.dart';
import 'package:solo/screen/pages/settings.dart';
import 'package:solo/screen/pages/about.dart';
import 'package:solo/screen/widgets/global.dart';

class Route {
  final String path;
  final Widget Function(BuildContext, GoRouterState) builder;
  final String name;
  Route({required this.path, required this.builder, required this.name});
}

class RouterDefinition {
  static Route root = Route(
      path: '/',
      name: '/',
      builder: (context, state) => BulderWidget(child: const HomePage()));

  static Route calendar = Route(
      path: '/calendar',
      name: '/calendar',
      builder: (context, state) => BulderWidget(child: const CalendarPage()));

  static Route timer = Route(
      path: '/timer',
      name: '/timer',
      builder: (context, state) => BulderWidget(child: const TimerPage()));

  static Route menu = Route(
      path: '/menu',
      name: '/menu',
      builder: (context, state) => BulderWidget(child: const MenuPage()));

  static Route todoList = Route(
      path: '/todo-list',
      name: '/todo-list',
      builder: (context, state) => BulderWidget(child: const TodoListPage()));

  static Route settings = Route(
      path: '/settings',
      name: '/settings',
      builder: (context, state) => BulderWidget(child: const SettingsPage()));

  static Route about = Route(
      path: '/about',
      name: '/about',
      builder: (context, state) => BulderWidget(child: const AboutPage()));
}

void nextRouting(BuildContext context, Route route) {
  GoRouter.of(context).go(route.path);
}

final GlobalKey<NavigatorState> navigationNavigatorKey =
    GlobalKey<NavigatorState>();
final appRouter = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: navigationNavigatorKey,
        builder: (context, state, child) {
          return GlobalLayout(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: RouterDefinition.root.name,
            builder: RouterDefinition.root.builder,
          ),
          GoRoute(
            path: RouterDefinition.calendar.name,
            builder: RouterDefinition.calendar.builder,
          ),
          GoRoute(
            path: RouterDefinition.timer.name,
            builder: RouterDefinition.timer.builder,
          ),
          GoRoute(
            path: RouterDefinition.todoList.name,
            builder: RouterDefinition.todoList.builder,
          ),
          GoRoute(
            path: RouterDefinition.menu.name,
            builder: RouterDefinition.menu.builder,
          ),
          GoRoute(
            path: RouterDefinition.settings.name,
            builder: RouterDefinition.settings.builder,
          ),
          GoRoute(
            path: RouterDefinition.about.name,
            builder: RouterDefinition.about.builder,
          ),
        ],
      ),
    ],
    initialLocation: RouterDefinition.root.name,
  );
});
