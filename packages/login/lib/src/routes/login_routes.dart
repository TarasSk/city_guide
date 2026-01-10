import 'package:flutter/widgets.dart';
import 'package:dependencies/dependencies.dart';
import 'package:login/src/login_page.dart';

part 'login_routes.g.dart';

/// Route constants for the login feature.
abstract final class LoginRoutes {
  /// The path for the login page.
  static const String login = '/login';
}

/// Type-safe route for the login page.
@TypedGoRoute<LoginRoute>(path: LoginRoutes.login)
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}
