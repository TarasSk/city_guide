import 'dart:async';

import 'package:auth/auth.dart';
import 'package:city_guide_app/router/router.dart';
import 'package:core/core.dart';

// ignore_for_file: prefer-static-class

/// Global service locator instance.
final injector = GetIt.instance;

/// Initialize all dependencies.
///
/// This lives at the app level (not in core) because it registers
/// feature-specific dependencies (auth, etc.).
FutureOr<void> init() async {
  await _registerAppDependency();
  await _registerRepositories();
  await _registerGlobalBlocs();
}

Future<void> _registerAppDependency() async {
  injector
    ..registerLazySingleton<GoRouter>(() => AppRouter.router)
    ..registerSingleton<SharedPreferencesAbstract>(
      SharedPreferencesImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
    )
    ..registerLazySingleton<Logger>(
      () => Logger(
        printer: PrettyPrinter(
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
          printEmojis: false,
        ),
      ),
    )
    ..registerLazySingleton<LoggerAbstract>(
      () => LoggerImpl(
        logger: injector(),
      ),
    )
    ..registerLazySingleton<FirebaseAnalytics>(
      () => FirebaseAnalytics.instance,
    );
}

Future<void> _registerRepositories() async {
  injector
    ..registerLazySingleton<GoogleSignIn>(
      GoogleSignIn.new,
    )
    ..registerLazySingleton<FirebaseAuth>(
      () => FirebaseAuth.instance,
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        firebaseAuth: injector(),
        googleSignIn: injector(),
      ),
    );
}

Future<void> _registerGlobalBlocs() async {
  injector
    ..registerLazySingleton<AppBlocObserver>(
      () => AppBlocObserver(
        logger: injector(),
        analytics: injector(),
      ),
    )
    ..registerLazySingleton<ThemeBloc>(
      () => ThemeBloc(
        sharedPreferences: injector(),
      ),
    )
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        authRepository: injector(),
      ),
    );
}
