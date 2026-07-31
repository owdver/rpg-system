import 'package:flutter/foundation.dart';

/// Application-wide logging service.
/// Provides structured logging with different severity levels.
class LoggerService {
  LoggerService._();

  static final LoggerService instance = LoggerService._();

  static const _defaultLoggerName = 'RPGSystem';

  bool _initialized = false;
  LogLevel _minimumLevel = LogLevel.debug;
  bool _enableConsole = true;

  /// Initialize the logging system.
  void initialize({
    LogLevel minimumLevel = LogLevel.debug,
    bool enableConsole = true,
    bool enableFile = false,
  }) {
    if (_initialized) return;
    _initialized = true;
    _minimumLevel = minimumLevel;
    _enableConsole = enableConsole;

    // Immediately print initialization
    _printLog(
        LogLevel.info, 'RPGSystem', 'LoggerService initialized', null, null);
  }

  LogLevel get minimumLevel => _minimumLevel;
  bool get enableConsole => _enableConsole;

  /// Get a logger instance for a specific component.
  Logger getLogger(String name) {
    return Logger(name);
  }

  /// Get the default logger.
  Logger get logger => getLogger(_defaultLoggerName);

  void _printLog(LogLevel level, String name, String message, Object? error,
      StackTrace? stackTrace) {
    if (level.value < _minimumLevel.value) return;

    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    final buffer = StringBuffer();
    buffer.write('[$timestamp] [${level.name.toUpperCase()}] [$name] ');
    buffer.write(message);
    if (error != null) {
      buffer.write(' | Error: $error');
    }
    if (stackTrace != null && level.value >= LogLevel.error.value) {
      buffer.write('\n  StackTrace: $stackTrace');
    }

    // Use debugPrint for console output
    debugPrint(buffer.toString());
  }
}

/// Application log levels.
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  fatal;

  int get value {
    return switch (this) {
      LogLevel.verbose => 0,
      LogLevel.debug => 100,
      LogLevel.info => 200,
      LogLevel.warning => 300,
      LogLevel.error => 400,
      LogLevel.fatal => 500,
    };
  }
}

/// A typed logger interface for application components.
class Logger {
  const Logger(this.name);

  final String name;

  void verbose(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.verbose, message, error, stackTrace);
  }

  void debug(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  void info(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  void warning(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, error, stackTrace);
  }

  void error(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  void fatal(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.fatal, message, error, stackTrace);
  }

  void _log(
      LogLevel level, Object? message, Object? error, StackTrace? stackTrace) {
    // Check minimum level
    if (level.value < LoggerService.instance.minimumLevel.value) return;

    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    final logMessage = message?.toString() ?? '';
    final errorMsg = error?.toString();
    final stackMsg = stackTrace?.toString();

    final buffer = StringBuffer();
    buffer.write('[$timestamp] [${level.name.toUpperCase()}] [$name] ');
    buffer.write(logMessage);
    if (errorMsg != null) {
      buffer.write(' | Error: $errorMsg');
    }
    if (stackMsg != null && level.value >= LogLevel.error.value) {
      buffer.write('\n  StackTrace: $stackMsg');
    }

    debugPrint(buffer.toString());
  }

  /// Log a method entry.
  void enter(String methodName, [Map<String, Object?>? params]) {
    final paramsStr = params != null
        ? ', ${params.entries.map((e) => '${e.key}=${e.value}').join(', ')}'
        : '';
    debug('→ $methodName($paramsStr)');
  }

  /// Log a method exit.
  void exit(String methodName, [Object? result]) {
    final resultStr = result != null ? ' => $result' : '';
    debug('← $methodName$resultStr');
  }

  /// Log an operation start.
  void startOperation(String operation) {
    debug('▶ Starting: $operation');
  }

  /// Log an operation completion.
  void completeOperation(String operation, [Object? result]) {
    final resultStr = result != null ? ' => $result' : '';
    debug('✓ Completed: $operation$resultStr');
  }

  /// Log an operation failure.
  void failOperation(String operation, Object err, [StackTrace? stackTrace]) {
    error('✗ Failed: $operation', err, stackTrace);
  }
}
