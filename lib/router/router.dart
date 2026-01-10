import 'package:auth/auth.dart';
import 'package:city_guide_app/di/injection_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:home/home.dart';
import 'package:login/login.dart';
import 'package:presentation/presentation.dart';

/// Application router configuration.
///
/// This composes routes from feature packages to create the full app router.
class AppRouter {
  AppRouter._();

  static Future<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final loggedIn = context.read<AuthBloc>().state is AuthAuthenticated;
    final onLoginPage = state.matchedLocation == LoginRoutes.login;
    final onSplashPage = state.matchedLocation == PresentationRoutes.splash;

    if (!loggedIn) {
      return LoginRoutes.login;
    }
    if (onLoginPage || onSplashPage) {
      return HomeRoutes.home;
    }

    // No need to redirect at all.
    return null;
  }

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: PresentationRoutes.splash,
    debugLogDiagnostics: true,
    redirect: _redirect,
    routes: _appRoutes,
    observers: [
      FirebaseAnalyticsObserver(analytics: injector<FirebaseAnalytics>()),
    ],
  );

  static final List<RouteBase> _appRoutes = [
    // Splash route from presentation package.
    $splashRoute,
    // Login route from login package.
    $loginRoute,
    // Main shell with tabs.
    PresentationRouter.mainShellRoute(
      branches: [
        StatefulShellBranch(
          routes: [
            // Home tab routes.
            $homeRoute,
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/map',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Map')),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Profile')),
              ),
            ),
          ],
        ),
      ],
    ),
  ];

  static GoRouter get router => _router;
}
