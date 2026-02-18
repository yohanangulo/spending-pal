import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class LoggerModule {
  @lazySingleton
  Logger get logger {
    final levelPrefixes = {
      Level.trace: '[T]',
      Level.debug: '[🐛]',
      Level.info: '[💡]',
      Level.warning: '[⚠️]',
      Level.error: '[⛔]',
      Level.fatal: '[🔥]',
    };

    for (final level in SimplePrinter.levelPrefixes.entries) {
      SimplePrinter.levelPrefixes[level.key] = levelPrefixes[level.key]!;
    }

    return Logger(printer: SimplePrinter(colors: false));
  }
}
