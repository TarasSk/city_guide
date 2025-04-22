import 'package:city_guide_app/features/home/pages/home_page.dart';
import 'package:city_guide_app/src/application/router/routes.dart';
import 'package:go_router/go_router.dart';

class HomeRouterModule {
  static final List<GoRoute> routes = [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomePage(),
    )
  ];
}
