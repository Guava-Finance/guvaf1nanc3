// features/core/services/navigation_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/routes/cache.dart';
import 'package:guava/core/routes/cache/lazy_route_loader.dart';
import 'package:guava/core/routes/router.dart';

/// Provider for the navigation service
final navigationService = Provider<NavigationService>((ref) {
  final service = NavigationService();
  // Dispose the service when the provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

/// Service for centralized navigation management
class NavigationService {
  // Cache for route widgets
  final Map<String, Widget> _routeCache = {};
  // Cache for route states
  final Map<String, GoRouterState> _stateCache = {};
  // Maximum cache size
  static const int _maxCacheSize = 10;
  // Cache expiration time in milliseconds (5 minutes)
  static const int _cacheExpirationTime = 5 * 60 * 1000;
  // Cache timestamps
  final Map<String, int> _cacheTimestamps = {};

  /// Navigate to a named route
  Future<void> navigateTo(
    BuildContext context,
    String routeName, {
    Object? extra,
  }) async {
    try {
      // If route is in high priority list, preload it
      if (_isHighPriorityRoute(routeName)) {
        await _prefetchRoute(context, routeName, extra);
      }

      if (context.mounted) {
        // Then navigate
        context.goNamed(routeName, extra: extra);
      }
    } catch (e) {
      if (context.mounted) {
        // Fallback navigation if something goes wrong
        context.go(Strings.dashboard);
      }
    }
  }

  /// Navigate to a route path
  Future<void> navigateToPath(BuildContext context, String path,
      {Object? extra}) async {
    try {
      // If route is in high priority list, preload it
      if (_isHighPriorityPath(path)) {
        await _prefetchPath(context, path, extra);
      }

      if (context.mounted) {
        // Then navigate
        context.go(path, extra: extra);
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
      if (context.mounted) {
        // Fallback navigation if something goes wrong
        context.go(Strings.dashboard);
      }
    }
  }

  /// Navigate and replace current route
  void replaceTo(BuildContext context, String routeName, {Object? extra}) {
    try {
      context.goNamed(routeName, extra: extra);
    } catch (e) {
      debugPrint('Navigation error: $e');
      context.go(Strings.dashboard);
    }
  }

  /// Go back to previous route
  void goBack(BuildContext context, [data]) {
    if (context.canPop()) {
      context.pop(data);
    } else {
      // If can't go back, go to dashboard
      context.go(Strings.dashboard);
    }
  }

  /// Check if a named route is high priority
  bool _isHighPriorityRoute(String routeName) {
    // List of high priority routes that should be preloaded
    final highPriorityRoutes = {
      Strings.dashboard.pathToName,
      Strings.transaction.pathToName,
      // Add other high priority routes
    };

    return highPriorityRoutes.contains(routeName);
  }

  /// Check if a path is high priority
  bool _isHighPriorityPath(String path) {
    // List of high priority paths that should be preloaded
    final highPriorityPaths = {
      Strings.dashboard,
      Strings.transaction,
      // Add other high priority paths
    };

    return highPriorityPaths.contains(path);
  }

  /// Prefetch a route by name for faster loading
  Future<void> _prefetchRoute(
    BuildContext context,
    String routeName,
    Object? extra,
  ) async {
    try {
      // Access router through context
      final router = GoRouter.of(context);
      final route = router.namedLocation(routeName);
      await _prefetchPath(context, route, extra);
    } catch (e) {
      debugPrint('Error prefetching route $routeName: $e');
    }
  }

  late ValueListenable<RoutingConfig> _routingConfig;

  /// Prefetch a route by path for faster loading
  Future<void> _prefetchPath(
    BuildContext context,
    String path,
    Object? extra,
  ) async {
    try {
      // Access router through context
      final router = GoRouter.of(context);

      // Check if route is already cached and not expired
      if (_isRouteCached(path)) {
        return;
      }

      // Find the matching route
      final matches = router.routerDelegate.currentConfiguration.matches;
      for (final match in matches) {
        for (final route in match.route.routes) {
          if (route is GoRoute && route.path == path) {
            // Create the widget but don't mount it yet
            if (route.builder != null) {
              final state = GoRouterState(
                RouteConfiguration(
                  _routingConfig,
                  navigatorKey: navkey,
                ),
                uri: Uri.parse(path),
                matchedLocation: path,
                name: route.name,
                path: route.path,
                extra: extra,
                pageKey: const ValueKey('prefetch'),
                pathParameters: const {},
                fullPath: path,
                error: null,
              );

              final widget = route.builder!(context, state);

              // Cache the route and state
              _cacheRoute(path, widget, state);

              // Prefetch the widget
              await LazyRouteLoader.prefetch(context, widget);

              // Cache the route in the global cache manager
              CachedRouteManager.cacheRoute(path, priority: CachePriority.high);
              return;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error prefetching path $path: $e');
    }
  }

  /// Cache a route and its state
  void _cacheRoute(String path, Widget widget, GoRouterState state) {
    // Remove oldest entry if cache is full
    if (_routeCache.length >= _maxCacheSize) {
      _removeOldestCacheEntry();
    }

    // Add new entry
    _routeCache[path] = widget;
    _stateCache[path] = state;
    _cacheTimestamps[path] = DateTime.now().millisecondsSinceEpoch;
  }

  /// Check if a route is cached and not expired
  bool _isRouteCached(String path) {
    final timestamp = _cacheTimestamps[path];
    if (timestamp == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - timestamp) < _cacheExpirationTime;
  }

  /// Remove the oldest cache entry
  void _removeOldestCacheEntry() {
    if (_cacheTimestamps.isEmpty) return;

    String? oldestPath;
    int? oldestTimestamp;

    for (final entry in _cacheTimestamps.entries) {
      if (oldestTimestamp == null || entry.value < oldestTimestamp) {
        oldestPath = entry.key;
        oldestTimestamp = entry.value;
      }
    }

    if (oldestPath != null) {
      _routeCache.remove(oldestPath);
      _stateCache.remove(oldestPath);
      _cacheTimestamps.remove(oldestPath);
    }
  }

  /// Clear the entire cache
  void clearCache() {
    _routeCache.clear();
    _stateCache.clear();
    _cacheTimestamps.clear();
  }

  /// Dispose resources
  void dispose() {
    clearCache();
  }
}
