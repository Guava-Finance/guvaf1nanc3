import 'package:flutter/widgets.dart';

class WidgetCache {
  static final Map<String, Widget> _cache = {};
  static const int _maxSize = 20;

  static void cacheWidget(String key, Widget widget) {
    if (_cache.length >= _maxSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = widget;
  }

  static Widget? getWidget(String key) => _cache[key];
}
