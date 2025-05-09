import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/routes/cache.dart';
import 'package:guava/features/dashboard/presentation/pages/dashboard_page.dart';

/// Dashboard related routes
final List<RouteBase> dashboardRoutes = [
  GoRoute(
    name: Strings.dashboard.pathToName,
    path: Strings.dashboard,
    builder: (context, state) {
      // Cache this high-frequency route
      CachedRouteManager.cacheRoute(
        state.fullPath ?? '',
        priority: CachePriority.high,
      );
      return const DashboardPage();
    },
  ),
];
