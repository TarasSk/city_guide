import 'dart:async';

import 'package:auth/auth.dart';
import 'package:core/src/blocs/bloc_observer.dart';
import 'package:core/src/blocs/theme/theme_bloc.dart';
import 'package:core/src/logger/logger_abstract.dart';
import 'package:core/src/logger/logger_impl.dart';
import 'package:core/src/shared_preferences/shared_preferences_abstract.dart';
import 'package:core/src/shared_preferences/shared_preferences_impl.dart';
import 'package:dependencies/dependencies.dart';

// ignore_for_file: prefer-static-class
final injector = GetIt.instance;

FutureOr<void> init() async {
  await _registerAppDependency();
  await _registerRepositories();
  await _registerGlobalBlocs();
}

Future<void> _registerAppDependency() async {
  injector
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
