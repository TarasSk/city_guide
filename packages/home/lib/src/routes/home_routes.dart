import 'package:flutter/widgets.dart';
import 'package:dependencies/dependencies.dart';
import 'package:home/src/home_page.dart';

part 'home_routes.g.dart';

/// Route constants for the home feature.
abstract final class HomeRoutes {
  /// The path for the home page.
  static const String home = '/home';
}

/// Type-safe route for the home page.
@TypedGoRoute<HomeRoute>(path: HomeRoutes.home)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}
