// Create a custom image cache manager
import 'dart:typed_data';

class CustomImageCache {
  static final Map<String, Uint8List> _cache = {};
  static const int _maxSize = 100; // Maximum number of cached images

  static void cacheImage(String key, Uint8List bytes) {
    if (_cache.length >= _maxSize) {
      _cache.remove(_cache.keys.first); // Remove oldest
    }
    _cache[key] = bytes;
  }

  static Uint8List? getImage(String key) => _cache[key];
}
