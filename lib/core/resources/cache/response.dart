class ResponseCache {
  static final Map<String, dynamic> _cache = {};
  static final Map<String, DateTime> _timestamps = {};
  static const Duration _expirationTime = Duration(minutes: 5);

  static void cacheResponse(String key, dynamic data) {
    _cache[key] = data;
    _timestamps[key] = DateTime.now();
  }

  static dynamic getResponse(String key) {
    final timestamp = _timestamps[key];
    if (timestamp == null) return null;

    if (DateTime.now().difference(timestamp) > _expirationTime) {
      _cache.remove(key);
      _timestamps.remove(key);
      return null;
    }
    return _cache[key];
  }
}
