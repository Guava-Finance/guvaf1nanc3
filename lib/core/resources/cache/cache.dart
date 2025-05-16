import 'dart:async';

/// A generic cache manager that handles different types of data
class CacheManager<T> {
  final int maxSize;
  final Duration expirationTime;
  final Map<String, _CacheEntry<T>> _cache = {};
  final _cacheController = StreamController<String>.broadcast();

  /// Stream that emits when a cache entry is removed
  Stream<String> get onEntryRemoved => _cacheController.stream;

  CacheManager({
    this.maxSize = 100,
    this.expirationTime = const Duration(minutes: 5),
  });

  /// Add an item to the cache
  void put(String key, T value) {
    _cleanup();
    
    if (_cache.length >= maxSize) {
      _removeOldest();
    }

    _cache[key] = _CacheEntry(
      value: value,
      timestamp: DateTime.now(),
    );
  }

  /// Get an item from the cache
  T? get(String key) {
    _cleanup();
    
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired(expirationTime)) {
      remove(key);
      return null;
    }

    return entry.value;
  }

  /// Check if an item exists in the cache
  bool contains(String key) {
    _cleanup();
    return _cache.containsKey(key) && !_cache[key]!.isExpired(expirationTime);
  }

  /// Remove an item from the cache
  void remove(String key) {
    _cache.remove(key);
    _cacheController.add(key);
  }

  /// Clear all items from the cache
  void clear() {
    _cache.clear();
    _cacheController.add('all');
  }

  /// Get the current size of the cache
  int get size => _cache.length;

  /// Remove expired entries
  void _cleanup() {
    final now = DateTime.now();
    _cache.removeWhere((key, entry) {
      if (entry.isExpired(expirationTime)) {
        _cacheController.add(key);
        return true;
      }
      return false;
    });
  }

  /// Remove the oldest entry
  void _removeOldest() {
    if (_cache.isEmpty) return;

    String? oldestKey;
    DateTime? oldestTime;

    for (final entry in _cache.entries) {
      if (oldestTime == null || entry.value.timestamp.isBefore(oldestTime)) {
        oldestKey = entry.key;
        oldestTime = entry.value.timestamp;
      }
    }

    if (oldestKey != null) {
      remove(oldestKey);
    }
  }

  /// Dispose the cache manager
  void dispose() {
    clear();
    _cacheController.close();
  }
}

/// A cache entry that holds the value and its timestamp
class _CacheEntry<T> {
  final T value;
  final DateTime timestamp;

  _CacheEntry({
    required this.value,
    required this.timestamp,
  });

  bool isExpired(Duration expirationTime) {
    return DateTime.now().difference(timestamp) > expirationTime;
  }
}

/// A singleton instance for managing different types of caches
// class AppCache {
//   static final AppCache _instance = AppCache._internal();
//   factory AppCache() => _instance;
//   AppCache._internal();

//   // Different cache instances for different types of data
//   final imageCache = CacheManager<Uint8List>(maxSize: 50);
//   final responseCache = CacheManager<dynamic>(maxSize: 100);
//   final widgetCache = CacheManager<Widget>(maxSize: 20);

//   /// Clear all caches
//   void clearAll() {
//     imageCache.clear();
//     responseCache.clear();
//     widgetCache.clear();
//   }

//   /// Dispose all caches
//   void dispose() {
//     imageCache.dispose();
//     responseCache.dispose();
//     widgetCache.dispose();
//   }
// }