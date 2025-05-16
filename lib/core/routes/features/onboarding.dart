// features/router/onboarding_routes.dart
import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/routes/cache.dart';
import 'package:guava/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:guava/features/onboarding/presentation/pages/setup_pin_page.dart';
import 'package:guava/features/onboarding/presentation/pages/wallet_recovery/add_connect_wallet.dart';
import 'package:guava/features/onboarding/presentation/pages/wallet_recovery/private_key.dart';
import 'package:guava/features/onboarding/presentation/pages/wallet_recovery/recovery_phase.dart';

/// Onboarding related routes
final List<RouteBase> onboardingRoutes = [
  GoRoute(
    name: Strings.onboarding.pathToName,
    path: Strings.onboarding,
    builder: (context, state) {
      // Cache this route for faster subsequent access
      CachedRouteManager.cacheRoute(state.fullPath!);
      return const Onboardingpage();
    },
  ),
  GoRoute(
    name: Strings.setupPin.pathToName,
    path: Strings.setupPin,
    builder: (context, state) => SetupPinPage(),
  ),
  GoRoute(
    name: Strings.addConnectWallet.pathToName,
    path: Strings.addConnectWallet,
    builder: (context, state) => const WalletRecoveryOptions(),
  ),
  GoRoute(
    name: Strings.importRecoveryPhrase.pathToName,
    path: Strings.importRecoveryPhrase,
    builder: (context, state) => const ImportRecoveryPhrase(),
  ),
  GoRoute(
    name: Strings.importPrivateKey.pathToName,
    path: Strings.importPrivateKey,
    builder: (context, state) => const ImportPrivateKey(),
  ),
];
