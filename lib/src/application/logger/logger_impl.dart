import 'package:city_guide_app/src/application/logger/logger_abstract.dart';
import 'package:logger/logger.dart';

/// Implementation of the [LoggerAbstract] class using the logger package
/// This class provides methods to log messages at different levels
/// such as verbose, debug, info, warning, error, and fatal.
class LoggerImpl extends LoggerAbstract {
  /// Constructor that takes a [Logger] instance
  /// and initializes the logger.
  LoggerImpl({required this.logger});

  /// External library member.
  final Logger logger;

  @override
  void setMinimumLoggerLevel(LoggerLevel loggerLevel) {
    switch (loggerLevel) {
      case LoggerLevel.verbose:
        Logger.level = Level.trace;
        break;
      case LoggerLevel.debug:
        Logger.level = Level.debug;
        break;
      case LoggerLevel.info:
        Logger.level = Level.info;
        break;
      case LoggerLevel.warning:
        Logger.level = Level.warning;
        break;
      case LoggerLevel.error:
        Logger.level = Level.error;
        break;
      case LoggerLevel.fatal:
        Logger.level = Level.fatal;
        break;
    }
  }

  @override
  void verbose(Object message) {
    logger.t(message);
  }

  @override
  void debug(Object message) {
    logger.d(message);
  }

  @override
  void info(Object message) {
    logger.i(message);
  }

  @override
  void warning(Object message) {
    logger.w(message);
  }

  @override
  void error(Object message) {
    logger.e(message);
  }

  @override
  void fatal(
    Object message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    logger.f(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
