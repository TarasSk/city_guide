import 'dart:async';

import 'package:city_guide_app/src/application/router/router.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final injector = GetIt.instance;

FutureOr<void> init() async {
  await _registerRouter();
  await _registerRepositories();
}

Future<void> _registerRouter() async {
  injector.registerSingleton<GoRouter>(AppRouter.createRouter());
}
Future<void> _registerRepositories() async {
  // TODO: Add repository registration logic here
}
