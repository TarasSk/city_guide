import 'package:auth/auth.dart';
import 'package:city_guide_app/di/injection_container.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              injector<ThemeBloc>()..add(const GetThemeEvent()),
        ),
        BlocProvider(create: (context) => injector<AuthBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final themeMode = switch (state) {
            ThemeDark() => ThemeMode.dark,
            ThemeLight() => ThemeMode.light,
            _ => ThemeMode.system,
          };

          return MaterialApp.router(
            title: 'City Guide App',
            routerDelegate: _appRouter.routerDelegate,
            routeInformationParser: _appRouter.routeInformationParser,
            routeInformationProvider: _appRouter.routeInformationProvider,
            themeMode: themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSwatch(),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.red,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
          );
        },
      ),
    );
  }
}
