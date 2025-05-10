import 'package:city_guide_app/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:city_guide_app/src/application/blocs/theme/theme_bloc.dart';
import 'package:city_guide_app/src/application/di/injection_container.dart';
import 'package:city_guide_app/src/application/di/injection_container.dart'
    as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              di.injector<ThemeBloc>()..add(const GetThemeEvent()),
        ),
        BlocProvider(create: (context) => di.injector<AuthBloc>()),
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
