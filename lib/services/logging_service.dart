import 'dart:io';

enum LogLevel { debug, info, progress, success, warning, error }

class LoggingService {
  static bool _verboseMode = false;
  static bool _suppressEmojis = false;

  static void setVerboseMode(bool verbose) {
    _verboseMode = verbose;
  }

  static void setSuppressEmojis(bool suppress) {
    _suppressEmojis = suppress;
  }

  static bool get isVerbose => _verboseMode;

  /// Main logging method with different levels
  static void log(
    String message, {
    LogLevel level = LogLevel.info,
    bool forceOutput = false,
    bool showTimestamp = false,
  }) {
    // Skip debug messages unless in verbose mode
    if (level == LogLevel.debug && !_verboseMode && !forceOutput) {
      return;
    }

    final buffer = StringBuffer();

    // Add timestamp if requested
    if (showTimestamp) {
      final now = DateTime.now();
      buffer.write('[${_formatTime(now)}] ');
    }

    // Add level indicator
    final levelInfo = _getLevelInfo(level);
    buffer.write(levelInfo.prefix);
    if (!_suppressEmojis && levelInfo.emoji.isNotEmpty) {
      buffer.write(levelInfo.emoji);
      buffer.write(' ');
    }

    buffer.write(message);

    // Output to appropriate stream
    if (level == LogLevel.error) {
      stderr.writeln(buffer.toString());
    } else {
      stdout.writeln(buffer.toString());
    }
  }

  /// Convenience methods for different log levels
  static void debug(String message, {bool showTimestamp = false}) {
    log(message, level: LogLevel.debug, showTimestamp: showTimestamp);
  }

  static void info(String message, {bool showTimestamp = false}) {
    log(message, level: LogLevel.info, showTimestamp: showTimestamp);
  }

  static void progress(String message, {bool showTimestamp = false}) {
    log(message, level: LogLevel.progress, showTimestamp: showTimestamp);
  }

  static void success(String message, {bool showTimestamp = false}) {
    log(message, level: LogLevel.success, showTimestamp: showTimestamp);
  }

  static void warning(String message, {bool showTimestamp = false}) {
    log(message, level: LogLevel.warning, showTimestamp: showTimestamp);
  }

  static void error(String message, {bool showTimestamp = false}) {
    log(message, level: LogLevel.error, showTimestamp: showTimestamp);
  }

  /// Logs operation start
  static void logOperationStart(String operation, String target) {
    progress('Starting $operation for $target...');
  }

  /// Logs operation completion
  static void logOperationComplete(String operation, String target) {
    success('$operation completed successfully for $target');
  }

  /// Logs operation warning
  static void logOperationWarning(
    String operation,
    String target,
    String reason,
  ) {
    warning('$operation for $target: $reason');
  }

  /// Logs operation failure
  static void logOperationError(String operation, String target, String error) {
    LoggingService.error('$operation failed for $target: $error');
  }

  /// Creates a progress indicator for long-running operations
  static void logProgress(String operation, int current, int total) {
    if (!_verboseMode) return;

    final percentage = ((current / total) * 100).round();
    final progressBar = _createProgressBar(percentage);
    progress('$operation: $progressBar $current/$total ($percentage%)');
  }

  /// Internal methods
  static _LevelInfo _getLevelInfo(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return _LevelInfo('[DEBUG]', '🔍');
      case LogLevel.info:
        return _LevelInfo('[INFO]', 'ℹ️');
      case LogLevel.progress:
        return _LevelInfo('[PROGRESS]', '⏳');
      case LogLevel.success:
        return _LevelInfo('[SUCCESS]', '✅');
      case LogLevel.warning:
        return _LevelInfo('[WARNING]', '⚠️');
      case LogLevel.error:
        return _LevelInfo('[ERROR]', '❌');
    }
  }

  static String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }

  static String _createProgressBar(int percentage, {int width = 20}) {
    final filled = (width * percentage / 100).round();
    final empty = width - filled;
    return '[${('█' * filled)}${('░' * empty)}]';
  }

  /// Prints the BrandForge ASCII art introduction
  static void printIntroduction() {
    const brandForgeArt = '''
     ____                      _ ______
    |  _ \\                    | |  ____|
    | |_) |_ __ __ _ _ __   __| | |__ ___  _ __ __ _  ___
    |  _ <| '__/ _` | '_ \\ / _` |  __/ _ \\| '__/ _` |/ _ \\
    | |_) | | | (_| | | | | (_| | | | (_) | | | (_| |  __/
    |____/|_|  \\__,_|_| |_|\\__,_|_|  \\___/|_|  \\__, |\\___|
                                                __/ |
                                                |___/
    ''';

    info(brandForgeArt);
    info('Welcome to BrandForge! 🎉');
    info('This tool helps you dynamically change your app\'s name and icon.');
    info('Use --help to see available commands.');
  }
}

class _LevelInfo {
  final String prefix;
  final String emoji;

  const _LevelInfo(this.prefix, this.emoji);
}
