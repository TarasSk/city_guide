import 'package:city_guide_app/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:city_guide_app/features/login/presentation/login_page.dart';
import 'package:city_guide_app/presentation/pages/main_page.dart';
import 'package:city_guide_app/presentation/pages/splash_page.dart';
import 'package:city_guide_app/src/application/di/injection_container.dart'
    as di;
import 'package:city_guide_app/src/application/router/home_router_module.dart';
import 'package:city_guide_app/src/application/router/routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();
  static Future<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final loggedIn = context.read<AuthBloc>().state is AuthAuthenticated;
    final onLoginPage = state.matchedLocation == Routes.login;
    final onSplashPage = state.matchedLocation == Routes.splash;
    if (!loggedIn) {
      return Routes.login;
    }
    if (onLoginPage || onSplashPage) {
      return Routes.home;
    }

    // No need to redirect at all.
    return null;
  }

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    redirect: _redirect,
    routes: _appRoutes,
    observers: [
      FirebaseAnalyticsObserver(analytics: di.injector<FirebaseAnalytics>()),
    ],
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
