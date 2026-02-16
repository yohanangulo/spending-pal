import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';

Log get log => getIt<Log>();

@lazySingleton
class Log {
  Log(this._logger);

  final Logger _logger;

  StackTrace _removeFirstFrame(StackTrace stackTrace) {
    final lines = stackTrace.toString().split('\n');

    if (lines.length <= 1) {
      return stackTrace;
    }

    final cleaned = lines.sublist(1).join('\n');

    return StackTrace.fromString(cleaned);
  }

  void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(
      message,
      error: error,
      stackTrace: stackTrace ?? _removeFirstFrame(StackTrace.current),
    );
  }

  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(
      message,
      error: error,
      stackTrace: stackTrace ?? _removeFirstFrame(StackTrace.current),
    );
  }

  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(
      message,
      error: error,
      stackTrace: stackTrace ?? _removeFirstFrame(StackTrace.current),
    );
  }

  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(
      message,
      error: error,
      stackTrace: stackTrace ?? _removeFirstFrame(StackTrace.current),
    );
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace ?? _removeFirstFrame(StackTrace.current),
    );
  }
}
