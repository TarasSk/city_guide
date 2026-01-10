import 'package:flutter/widgets.dart';
import 'package:dependencies/dependencies.dart';
import 'package:presentation/src/main_page.dart';
import 'package:presentation/src/splash_page.dart';

part 'presentation_routes.g.dart';

/// Route constants for the presentation feature.
abstract final class PresentationRoutes {
  /// The path for the splash page.
  static const String splash = '/splash';
}

/// Type-safe route for the splash page.
@TypedGoRoute<SplashRoute>(path: PresentationRoutes.splash)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashPage();
  }
}

/// Creates the main shell route with the provided branches.
///
/// Note: ShellRoute is not supported by go_router_builder annotations,
/// so we provide a factory method instead.
abstract final class PresentationRouter {
  /// Creates the main shell route with the provided branches.
  ///
  /// The [branches] parameter should contain the tab routes for the app.
  static StatefulShellRoute mainShellRoute({
    required List<StatefulShellBranch> branches,
  }) {
    return StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainPage(
        navigationShell: navigationShell,
      ),
      branches: branches,
    );
  }
}
