import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:guava/features/onboarding/presentation/pages/setup_pin_page.dart';
import 'package:guava/features/onboarding/presentation/pages/splash.page.dart';

/// [p] suffix means path
const String pRoot = Strings.root;
const String pOnboarding = Strings.onboarding;
const String pDashboard = Strings.dashboard;
const String pSetupPin = Strings.setupPin;

/// GlobalKey for the Navigator state of the [AppName]
final GlobalKey<NavigatorState> navkey = GlobalKey();

// GoRouter configuration
final router = GoRouter(
  navigatorKey: navkey,
  routes: [
    GoRoute(
      name: pRoot.pathToName,
      path: pRoot,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      name: pOnboarding.pathToName,
      path: pOnboarding,
      builder: (context, state) => const Onboardingpage(),
    ),
    GoRoute(
      name: pDashboard.pathToName,
      path: pDashboard,
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      name: pSetupPin.pathToName,
      path: pSetupPin,
      builder: (context, state) => const SetupPinPage(),
    ),
  ],
);
