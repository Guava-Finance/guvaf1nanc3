import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:guava/core/cache/cache_manager.dart';

/// Example widget showing how to use the cache manager
class CacheExample extends StatefulWidget {
  const CacheExample({super.key});

  @override
  State<CacheExample> createState() => _CacheExampleState();
}

class _CacheExampleState extends State<CacheExample> {
  final _appCache = AppCache();
  String? _cachedImage;
  String? _cachedResponse;
  Widget? _cachedWidget;

  @override
  void initState() {
    super.initState();
    _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    // Example of caching an image
    final imageKey = 'profile_image';
    if (_appCache.imageCache.contains(imageKey)) {
      setState(() {
        _cachedImage = 'Image loaded from cache';
      });
    } else {
      // Simulate loading an image
      final imageBytes = await _loadImageFromNetwork();
      _appCache.imageCache.put(imageKey, imageBytes);
      setState(() {
        _cachedImage = 'Image loaded from network and cached';
      });
    }

    // Example of caching API response
    final responseKey = 'user_data';
    if (_appCache.responseCache.contains(responseKey)) {
      setState(() {
        _cachedResponse = 'Response loaded from cache';
      });
    } else {
      // Simulate API call
      final response = await _fetchUserData();
      _appCache.responseCache.put(responseKey, response);
      setState(() {
        _cachedResponse = 'Response loaded from API and cached';
      });
    }

    // Example of caching a widget
    final widgetKey = 'user_profile';
    if (_appCache.widgetCache.contains(widgetKey)) {
      setState(() {
        _cachedWidget = _appCache.widgetCache.get(widgetKey);
      });
    } else {
      final widget = _buildUserProfile();
      _appCache.widgetCache.put(widgetKey, widget);
      setState(() {
        _cachedWidget = widget;
      });
    }
  }

  Future<Uint8List> _loadImageFromNetwork() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return Uint8List.fromList([1, 2, 3, 4, 5]); // Dummy image data
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return {'name': 'John Doe', 'email': 'john@example.com'};
  }

  Widget _buildUserProfile() {
    return const Card(
      child: ListTile(
        title: Text('User Profile'),
        subtitle: Text('This widget is cached'),
      ),
    );
  }

  void _clearCache() {
    _appCache.clearAll();
    setState(() {
      _cachedImage = null;
      _cachedResponse = null;
      _cachedWidget = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cache Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearCache,
            tooltip: 'Clear Cache',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Image Cache'),
              subtitle: Text(_cachedImage ?? 'Loading...'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Response Cache'),
              subtitle: Text(_cachedResponse ?? 'Loading...'),
            ),
          ),
          const SizedBox(height: 8),
          if (_cachedWidget != null) _cachedWidget!,
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Don't dispose the AppCache here as it's a singleton
    // Only dispose if you're sure you won't need it anymore
    super.dispose();
  }
}
