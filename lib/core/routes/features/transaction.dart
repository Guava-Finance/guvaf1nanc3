
import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/routes/cache.dart';
import 'package:guava/features/home/presentation/pages/transactions/transaction_detail_page.dart';
import 'package:guava/features/home/presentation/pages/transactions/transaction_page.dart';

/// Transaction related routes
final List<RouteBase> transactionRoutes = [
  GoRoute(
    name: Strings.transaction.pathToName,
    path: Strings.transaction,
    builder: (context, state) {
      // Cache this frequently accessed route
      CachedRouteManager.cacheRoute(state.fullPath?? '/');
      return const TransactionPage();
    },
  ),
  GoRoute(
    name: Strings.transactionDetail.pathToName,
    path: Strings.transactionDetail,
    builder: (context, state) => const TransactionDetailPage(),
  ),
];
