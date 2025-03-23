import 'dart:async';

import 'package:city_guide_app/src/application/application.dart';
import 'package:flutter/material.dart';
import 'src/application/di/injection_container.dart' as di;

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    _registerDependencies();
    runApp(const Application());
  }, (error, stackTrace) {
    print('Error: $error');
    print('StackTrace: $stackTrace');
  });
}

Future<void> _registerDependencies() async {
  await di.init();
}
