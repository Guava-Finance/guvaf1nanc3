// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
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

    Future.delayed(const Duration(seconds: 2), () async {
      try {
        // Wait for wallet address to be available
        await ref.read(walletAddressProvider.future);

        // Check if access pin is set
        final isAccessCodeSet = await ref.read(isAccessPinSetProovider.future);

        if (isAccessCodeSet) {
          context.go(pDashboard);
        } else {
          _pinSetup(ref.read(onboardingNotifierProvider));
        }
      } catch (e) {
        AppLogger.log(e);
        context.push(pOnboarding);
      }
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
