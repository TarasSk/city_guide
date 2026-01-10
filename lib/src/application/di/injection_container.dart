import 'dart:async';

import 'package:city_guide_app/features/auth/data/auth_repository.dart';
import 'package:city_guide_app/features/auth/domain/auth_repository.dart';
import 'package:city_guide_app/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:city_guide_app/src/application/blocs/bloc_observer.dart';
import 'package:city_guide_app/src/application/blocs/theme/theme_bloc.dart';
import 'package:city_guide_app/src/application/logger/logger_abstract.dart';
import 'package:city_guide_app/src/application/logger/logger_impl.dart';
import 'package:city_guide_app/src/application/router/router.dart';
import 'package:city_guide_app/src/shared/shared_preferences/shared_preferences_abstract.dart';
import 'package:city_guide_app/src/shared/shared_preferences/shared_preferences_impl.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: prefer-static-class
final injector = GetIt.instance;

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
