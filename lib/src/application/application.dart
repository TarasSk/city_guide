import 'package:city_guide_app/src/application/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final _appRouter = injector<GoRouter>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'City Guide App',
      routerDelegate: _appRouter.routerDelegate,
      routeInformationParser: _appRouter.routeInformationParser,
      routeInformationProvider: _appRouter.routeInformationProvider,
    );
  }
}
