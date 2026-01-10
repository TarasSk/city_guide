import 'dart:async';

import 'package:city_guide_app/di/injection_container.dart';
import 'package:city_guide_app/firebase_options.dart';
import 'package:city_guide_app/src/application/application.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

void main() async {
  Future<void> registerDependencies() async => await init();

  Future<void> firebaseInit() async =>
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await firebaseInit();
      await registerDependencies();

      Bloc.observer = injector<AppBlocObserver>();

      runApp(const Application());
    },
    (error, stackTrace) {
      FlutterError.dumpErrorToConsole(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
        ),
        forceReport: true,
      );

      injector<LoggerAbstract>().fatal(
        'Fatal error occurred',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}
