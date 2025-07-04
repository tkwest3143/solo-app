import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/pages/home.dart';
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
}

nextRouting(BuildContext context, Route route) {
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
        ],
      ),
    ],
    initialLocation: RouterDefinition.root.name,
  );
});
