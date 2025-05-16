import 'dart:io';

import 'package:guava/core/resources/analytics/logger/logger.dart';

class MemoryMonitor {
  static void logMemoryUsage() {
    final usage = ProcessInfo.currentRss;
    AppLogger.log('Current memory usage: ${usage ~/ 1024}KB');
  }

  static void checkMemoryThreshold() {
    final usage = ProcessInfo.currentRss;
    if (usage > 100 * 1024 * 1024) {
      // 100MB threshold
      // Clear caches
      // CustomImageCache.clear();
      // ResponseCache.clear();
      // WidgetCache.clear();
    }
  }
}
