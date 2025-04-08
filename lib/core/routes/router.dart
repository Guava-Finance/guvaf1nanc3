import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:guava/features/splash/presentation/pages/splash.page.dart';

/// [p] suffix means path
const String pRoot = '/';
const String pOnboarding = Strings.onboarding;

/// GlobalKey for the Navigator state of the [AppName]
final GlobalKey<NavigatorState> navkey = GlobalKey();

// GoRouter configuration
final router = GoRouter(
  navigatorKey: navkey,
  routes: [
    GoRoute(
      name: '/',
      path: pRoot,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      name: 'onboarding',
      path: pOnboarding,
      builder: (context, state) => const Onboardingpage(),
    ),
  ],
);
