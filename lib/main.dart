import 'dart:async';

import 'package:city_guide_app/firebase_options.dart';
import 'package:city_guide_app/src/application/application.dart';
import 'package:city_guide_app/src/application/di/injection_container.dart'
    as di;
import 'package:city_guide_app/src/application/logger/logger_abstract.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  Future<void> registerDependencies() async => await di.init();

  Future<void> firebaseInit() async =>
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await firebaseInit();
      await registerDependencies();
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
      
      di.injector<LoggerAbstract>().fatal(
            'Fatal error occurred',
            error: error,
            stackTrace: stackTrace,
          );
    },
  );
}
