import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/presentation/pages/splash.page.dart';

/// [p] suffix means path
const String pRoot = '/';

/// GlobalKey for the Navigator state of the [AppName]
final GlobalKey<NavigatorState> navkey = GlobalKey();

// GoRouter configuration
final router = GoRouter(
  navigatorKey: navkey,
  routes: [
    GoRoute(
      name: 'splash',
      path: pRoot,
      builder: (context, state) => const SplashPage(),
    ),
  ],
);
