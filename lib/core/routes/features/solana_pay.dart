import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/features/transfer/presentation/pages/solana_pay/sp_payment_status_page.dart';
import 'package:guava/features/transfer/presentation/pages/solana_pay/sp_review_payment_page.dart';

final List<RouteBase> solanaPayRoutes = [
  // Solana Pay routes
  GoRoute(
    name: Strings.solanaPayReview.pathToName,
    path: Strings.solanaPayReview,
    builder: (context, state) => const ReviewSolanaPayDetailPage(),
  ),
  GoRoute(
    name: Strings.solanaPayStatus.pathToName,
    path: Strings.solanaPayStatus,
    builder: (context, state) => const SolanaPayStatusPage(),
  ),
];
