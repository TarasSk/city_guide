import 'dart:async';

import 'package:city_guide_app/src/application/application.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'src/application/di/injection_container.dart' as di;

final _logger = Logger('MainLogger');

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    _registerDependencies();
    runApp(const Application());
  }, (error, stackTrace) {
    _logger.severe('Error: $error');
    _logger.severe('StackTrace: $stackTrace');
  });
}

Future<void> _registerDependencies() async {
  await di.init();
}
