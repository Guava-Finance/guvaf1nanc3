import 'package:guava/core/resources/analytics/logger/logger.dart';

class PerformanceMonitor {
  static final Map<String, Stopwatch> _timers = {};

  static void startOperation(String key) {
    _timers[key] = Stopwatch()..start();
  }

  static void endOperation(String key) {
    final timer = _timers[key];

    if (timer != null) {
      timer.stop();
      AppLogger.log('Operation $key took ${timer.elapsedMilliseconds}ms');
      _timers.remove(key);
    }
  }
}
