import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/features/home/presentation/pages/guava_pay/guava_pay_disclaimer.dart';

/// Dashboard related routes
final List<RouteBase> guavaPayRoutes = [
  GoRoute(
    name: Strings.guavaPayDisclaimer.pathToName,
    path: Strings.guavaPayDisclaimer,
    builder: (context, state) {
      final String? data = state.extra as String?;

      return GuavaPayDisclaimer(encryptedData: data);
    },
  ),
];
