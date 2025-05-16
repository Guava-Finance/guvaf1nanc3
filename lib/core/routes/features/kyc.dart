// features/router/kyc_routes.dart
import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/features/kyc/presentation/pages/kyc_dart.dart';
import 'package:guava/features/kyc/presentation/pages/kyc_done.dart';

final List<RouteBase> kycRoutes = [
  GoRoute(
    name: Strings.kycPage.pathToName,
    path: Strings.kycPage,
    builder: (context, state) => const KycPage(),
  ),
  GoRoute(
    name: Strings.kycDonePage.pathToName,
    path: Strings.kycDonePage,
    builder: (context, state) => const KycDonePage(),
  ),
];
