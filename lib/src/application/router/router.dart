import 'package:city_guide_app/features/login/presentation/login_page.dart';
import 'package:city_guide_app/presentation/pages/main_page.dart';
import 'package:city_guide_app/presentation/pages/splash_page.dart';
import 'package:city_guide_app/src/application/router/home_router_module.dart';
import 'package:city_guide_app/src/application/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();
  static Future<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final loggedIn = false;
    final loggingIn = state.matchedLocation == Routes.login;
    // ignore: dead_code
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

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    redirect: _redirect,
    routes: _appRoutes,
  );

  static final List<RouteBase> _appRoutes = [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (
        context,
        state,
        navigationShell,
      ) =>
          MainPage(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            // Tab 1.
            ...HomeRouterModule.routes,
          ],
        ),
      ],
    ),
  ];

  static GoRouter get router => _router;
}
