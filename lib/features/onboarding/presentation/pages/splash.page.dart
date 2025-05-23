// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/resources/services/pubnub.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/onboarding/presentation/notifier/onboard.notifier.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        await (ref.read(configServiceProvider)).fetchConfig();
        // Wait for wallet address to be available
        await ref.read(walletAddressProvider.future);

        // Check if access pin is set
        final isAccessCodeSet = await ref.read(isAccessPinSetProovider.future);

        if (isAccessCodeSet) {
          context.push(pAccessPin, extra: true).then((v) {
            if (v != null && (v as bool)) {
              context.toPath(pDashboard);
            }
          });
        } else {
          _pinSetup(ref.read(onboardingNotifierProvider));
        }
      } catch (e) {
        context.push(pOnboarding);
      }

      // FlutterSecureStorage().deleteAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  void _pinSetup(OnboardingNotifier on) {
    navkey.currentContext!.go(pSetupPin);
  }
}
