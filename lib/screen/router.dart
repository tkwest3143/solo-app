import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/pages/home.dart';
import 'package:solo/screen/pages/calendar.dart';
import 'package:solo/screen/pages/timer.dart';
import 'package:solo/screen/pages/menu.dart';
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
      builder: (context, state) => const BulderWidget(child: HomePage()));

  static Route timer = Route(
      path: '/timer',
      name: '/timer',
      builder: (context, state) => BulderWidget(
            child: TimerPage(
              todoId: state.uri.queryParameters['todoId'],
              mode: state.uri.queryParameters['mode'],
            ),
          ));

  static Route menu = Route(
      path: '/menu',
      name: '/menu',
      builder: (context, state) => const BulderWidget(child: MenuPage()));

  static Route todoList = Route(
      path: '/todo-list',
      name: '/todo-list',
      builder: (context, state) => BulderWidget(
            child: CalendarPage(
              initialDate: state.uri.queryParameters['date'] != null
                  ? DateTime.tryParse(state.uri.queryParameters['date']!)
                  : null,
            ),
          ));

  static Route settings = Route(
      path: '/settings',
      name: '/settings',
      builder: (context, state) => const BulderWidget(child: SettingsPage()));

  static Route about = Route(
      path: '/about',
      name: '/about',
      builder: (context, state) => const BulderWidget(child: AboutPage()));
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
