import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/pages/home.dart';
import 'package:solo/screen/pages/user_add/complete.dart';
import 'package:solo/screen/pages/user_add/user_input.dart';
import 'package:solo/screen/pages/work_list.dart';
import 'package:solo/screen/pages/work_setting_add/work_setting_input.dart';
import 'package:solo/screen/pages/user_select.dart';
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
      builder: (contex, state) => BulderWidget(child: const UserSelectPage()));
  static Route home = Route(
      path: '/home',
      name: 'home',
      builder: (context, state) => BulderWidget(child: const HomePage()));
  static Route addUser = Route(
      path: '/addUser',
      name: 'addUser',
      builder: (context, state) => BulderWidget(child: const UserInputPage()));
  static Route userInputComplete = Route(
      path: '/addUser/userInputComplete',
      name: 'userInputComplete',
      builder: (context, state) {
        final userId = state.extra as int;
        return BulderWidget(child: UserInputCompletePage(userId: userId));
      });
  static Route addWorkSetting = Route(
      path: '/addWorkSetting',
      name: 'addWorkSetting',
      builder: (context, state) =>
          BulderWidget(child: const WorkSettingInputPage()));
  static Route workList = Route(
      path: '/workList',
      name: 'workList',
      builder: (context, state) => BulderWidget(child: const WorkListPage()));
}

nextRouting(BuildContext context, Route route) {
  GoRouter.of(context).go(route.path);
}

final appRouter = Provider<GoRouter>((ref) {
  final GlobalKey<NavigatorState> navigationNavigatorKey =
      GlobalKey<NavigatorState>();
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: RouterDefinition.root.name,
        builder: RouterDefinition.root.builder,
        routes: <RouteBase>[
          GoRoute(
              path: RouterDefinition.addUser.name,
              builder: RouterDefinition.addUser.builder,
              routes: [
                GoRoute(
                    name: RouterDefinition.userInputComplete.name,
                    path: RouterDefinition.userInputComplete.name,
                    builder: RouterDefinition.userInputComplete.builder)
              ]),
          GoRoute(
              path: RouterDefinition.addWorkSetting.name,
              builder: RouterDefinition.addWorkSetting.builder),
          ShellRoute(
            navigatorKey: navigationNavigatorKey,
            builder: (context, state, child) {
              return GlobalLayout(child: child);
            },
            routes: <RouteBase>[
              GoRoute(
                parentNavigatorKey: navigationNavigatorKey,
                path: RouterDefinition.home.name,
                builder: RouterDefinition.home.builder,
              ),
              GoRoute(
                parentNavigatorKey: navigationNavigatorKey,
                path: RouterDefinition.workList.name,
                builder: RouterDefinition.workList.builder,
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
