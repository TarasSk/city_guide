/// Levels to control the logging output.
enum LoggerLevel {
  /// Verbose log level.
  verbose,

  /// Debug log level.
  debug,

  /// Info log level.
  info,

  /// Warning log level.
  warning,

  /// Error log level.
  error,

  /// Fatal log level.
  fatal,
}

/// Abstract contract for implementing a logger library.
abstract class LoggerAbstract {
  /// Set the current logging level of the app
  /// all the output from logs with lower levels will be omitted.
  void setMinimumLoggerLevel(LoggerLevel loggerLevel);

  /// Log a message at [LoggerLevel.verbose] level.
  void verbose(Object message);

  /// Log a message at [LoggerLevel.debug] level.
  void debug(Object message);

  /// Log a message at [LoggerLevel.info] level.
  void info(Object message);

  /// Log a message at [LoggerLevel.warning] level.
  void warning(Object message);

  /// Log a message at [LoggerLevel.error] level.
  void error(Object message);

  /// Log a message at [LoggerLevel.fatal] level.
  void fatal(
    Object message, {
    Object? error,
    StackTrace? stackTrace,
  });
}
