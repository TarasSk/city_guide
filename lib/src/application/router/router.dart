import 'package:city_guide_app/features/home/home_router_module.dart';
import 'package:city_guide_app/presentation/pages/main_page.dart';
import 'package:city_guide_app/presentation/pages/splash_page.dart';
import 'package:city_guide_app/src/application/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    redirect: _redirect,
    routes: _appRoutes,
  );
}

final List<RouteBase> _appRoutes = [
  GoRoute(
    path: Routes.login,
    builder: (context, state) => SplashPage(),
  ),
  GoRoute(
      path: Routes.login,
      pageBuilder: (context, state) => MaterialPage(child: Container())),
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) => MainPage(
      navigationShell: navigationShell,
    ),
    branches: [
      StatefulShellBranch(
        routes: [
          // Tab 1
          ...HomeRouterModule.routes,
        ],
      )
    ],
  ),
];

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final loggedIn = true; //await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;
  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return Routes.home;
  }

  // no need to redirect at all
  return null;
}
