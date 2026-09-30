import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;

/// GLOBAL ACCESS LOG INSTANCE
/// You can import this file and call `logger.info('Hello')` anywhere in your app!
final Logger logger = LoggerLogging();

/// A shortcut type definition that lets you build custom log formatting functions easily.
typedef LogFormatter = String Function(LogMessage message, LogOptions options);

/// LOG PRIORITY LEVELS
/// Ordered from most critical (error) to least critical (verbose).
enum LoggerLevel implements Comparable<LoggerLevel> {
  error._(1000),   // Critical system failures
  warning._(800),  // Non-breaking warnings
  info._(600),     // General app updates (e.g., 'User logged in')
  debug._(400),    // Local variable checks during coding
  verbose._(200);  // Deep runtime system trace payloads

  const LoggerLevel._(this.value);
  final int value;

  @override
  int compareTo(LoggerLevel other) => value.compareTo(other.value);
}

/// LOGGER CONFIGURATION SETTINGS
base class LogOptions {
  const LogOptions({
    this.showTime = true,
    this.showEmoji = true,
    this.logInRelease = false, // Keep false so logs don't slow down the live App Store build
    this.level = LoggerLevel.info, // Hide everything below info level by default
    this.chunkSize = 1024,     // Maximum character length per console line print
    this.coloredOutput = true, // Enables colorful text outputs in the terminal
    this.formatter,
  });

  final LoggerLevel level;
  final bool showTime;
  final bool showEmoji;
  final bool logInRelease;
  final LogFormatter? formatter;
  final int chunkSize;
  final bool coloredOutput;
}

/// THE LOG DATA ENVELOPE
/// Collects all information about an event into a single structured package.
base class LogMessage {
  const LogMessage({
    required this.message,
    required this.logLevel,
    this.error,
    this.stackTrace,
    this.time,
  });

  final Object message;
  final Object? error;
  final StackTrace? stackTrace;
  final DateTime? time;
  final LoggerLevel logLevel;
}

/// THE ABSTRACT LOGGER CONTRACT
/// Outlines exactly what tools any logger built in this app must provide.
abstract base class Logger {
  void error(Object message, {Object? error, StackTrace? stackTrace});
  void warning(Object message);
  void info(Object message);
  void debug(Object message);
  void verbose(Object message);
  L runLogging<L>(L Function() fn, [LogOptions options = const LogOptions()]);
  Stream<LogMessage> get logs;

  /// CATCHES ASYNC BACKGROUND CRASHES
  /// Catches errors that happen inside asynchronous background methods.
  void logZoneError(Object error, StackTrace stackTrace) {
    this.error('Zone error caught: \$error', error: error, stackTrace: stackTrace);
  }

  /// CATCHES FLUTTER UI RENDERING FAULTS
  /// Intercepts UI layout issues (like overflow errors) without crashing the screen.
  void logFlutterError(FlutterErrorDetails details) {
    if (details.silent) return;
    error('Flutter UI Layout Error: \${details.exceptionAsString()}', error: details.exception, stackTrace: details.stack);
  }

  /// CATCHES NATIVE DEVICE HARDWARE ERRORS
  /// Catches underlying operating system or device communication breakdowns.
  bool logPlatformDispatcherError(Object error, StackTrace stackTrace) {
    this.error('Platform Engine Error: \$error', error: error, stackTrace: stackTrace);
    return true;
  }
}

/// THE CONCRETE LOGGING ENGINE IMPLEMENTATION
final class LoggerLogging extends Logger {
  // Uses Dart's official high-performance logging subsystem engine
  final _logger = logging.Logger('MedLogger');

  @override
  void debug(Object message) => _logger.fine(message);
  @override
  void error(Object message, {Object? error, StackTrace? stackTrace}) => _logger.severe(message, error, stackTrace);
  @override
  void info(Object message) => _logger.info(message);
  @override
  void verbose(Object message) => _logger.finest(message);
  @override
  void warning(Object message) => _logger.warning(message);

  @override
  Stream<LogMessage> get logs => _logger.onRecord.map((record) => record.toLogMessage());

  /// THE STARTUP BOOT WRAPPER
  /// Encloses your app initialization routine inside an active log tracker session.
  @override
  L runLogging<L>(L Function() fn, [LogOptions options = const LogOptions()]) {
    // Stop logging execution if the app is running in production mode
    if (kReleaseMode && !options.logInRelease) return fn();
    logging.hierarchicalLoggingEnabled = true;

    // Listen to our specific channel updates in real-time
    _logger.onRecord.where((event) => event.loggerName == 'MedLogger').listen((event) {
      final logMessage = event.toLogMessage();

      // Ignore the log if its priority level is below our current threshold filter
      if (logMessage.logLevel.compareTo(options.level) < 0) return;

      // Format the log using our standard layout parser configuration rule
      final message = options.formatter?.call(logMessage, options) ?? _formatLoggerMessage(log: logMessage, options: options);

      // If text payload exceeds the console width limit, chop it up to protect data visibility
      if (message.length > options.chunkSize) {
        _logWithChunks(message, options.chunkSize);
      } else {
        Zone.current.print(message);
      }
    });

    return fn();
  }

  /// THE PAYLOAD BREAKDOWN LOOP
  /// Prevents the terminal console buffer from dropping heavy data strings.
  void _logWithChunks(String message, int chunkSize) {
    for (var start = 0; start < message.length; start += chunkSize) {
      final end = (start + chunkSize) < message.length ? (start + chunkSize) : message.length;
      Zone.current.print(message.substring(start, end));
    }
  }
}

/// TEXT DISPLAY FORMATTER
/// Builds the string pattern you see printed on your console screen.
String _formatLoggerMessage({required LogMessage log, required LogOptions options}) {
  final buffer = StringBuffer();

  if (options.showEmoji) buffer.write('\${log.logLevel.emoji} ');
  if (options.showTime) buffer.write('\${log.time?.formatTime()} | ');
  buffer.write(log.message);
  if (log.error != null) buffer.write('\n❌ Details: \${log.error}');
  if (log.stackTrace != null) buffer.write('\n📌 Trace Location:\n\${log.stackTrace}');

  // Colorize output if target configuration rules allow it
  return options.coloredOutput ? _applyColor(buffer.toString(), log.logLevel) : buffer.toString();
}

/// THE ANSI SYSTEM COLORIZER
/// Automatically applies colors to terminal lines based on log severity levels.
String _applyColor(String message, LoggerLevel level) {
  const levelColors = <LoggerLevel, String>{
    LoggerLevel.error: '\x1B[31m',   // Red (Danger)
    LoggerLevel.warning: '\x1B[33m', // Yellow (Caution)
    LoggerLevel.info: '\x1B[32m',    // Green (Operational System Updates)
    LoggerLevel.debug: '\x1B[34m',   // Blue (Variable Checks)
    LoggerLevel.verbose: '\x1B[37m', // White (Deep Traces)
  };
  const resetColor = '\x1B[0m'; // Stops color leaking into subsequent lines
  return '\${levelColors[level]}messageresetColor';
}

// ============================================================================
// DATA MODEL TRANSLATION EXTENSIONS
// Helper code to format timestamps and convert package objects cleanly.
// ============================================================================

extension on DateTime {
  /// Formats raw time objects into a readable string pattern: "14:23:05"
  String formatTime() => [hour, minute, second].map((i) => i.toString().padLeft(2, '0')).join(':');
}

extension on logging.LogRecord {
  /// Converts official Dart logging objects into our custom [LogMessage] package structure.
  LogMessage toLogMessage() => LogMessage(
    message: message,
    error: error,
    stackTrace: stackTrace,
    time: time,
    logLevel: level.toLoggerLevel(),
  );
}

extension on logging.Level {
  /// Maps official Dart log priority codes into our custom simplified [LoggerLevel] markers.
  LoggerLevel toLoggerLevel() {
    if (value >= logging.Level.SEVERE.value) return LoggerLevel.error;
    if (value >= logging.Level.WARNING.value) return LoggerLevel.warning;
    if (value >= logging.Level.INFO.value) return LoggerLevel.info;
    if (value >= logging.Level.FINE.value) return LoggerLevel.debug;
    return LoggerLevel.verbose;
  }
}

extension on LoggerLevel {
  /// Maps each log level to a specific emoji indicator symbol.
  String get emoji => switch (this) {
    LoggerLevel.error => '🔥',   // System failure
    LoggerLevel.warning => '⚠️', // Warning
    LoggerLevel.info => '💡',    // Helpful information
    LoggerLevel.debug => '🐛',   // Debugging indicator
    LoggerLevel.verbose => '🔬', // Detailed analysis
  };
}
