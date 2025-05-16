// Extended functionality - Activity Detection Mixin
// You can add this to any widget that needs to track user activity
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/notification/wrapper/blur.dart';
import 'package:guava/core/routes/router.dart';

mixin UserActivityDetector<T extends StatefulWidget> on State<T> {
  Timer? _inactivityTimer;
  final Duration _inactivityDuration =
      const Duration(minutes: APP_TIMEOUT_MINUTES);

  @override
  void initState() {
    super.initState();
    _resetInactivityTimer();

    // Listen for any user interaction
    GestureBinding.instance.pointerRouter
        .addGlobalRoute(_handleUserInteraction);
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    GestureBinding.instance.pointerRouter
        .removeGlobalRoute(_handleUserInteraction);
    super.dispose();
  }

  void _handleUserInteraction(PointerEvent event) {
    // Reset timer on any user interaction
    if (event is PointerDownEvent) {
      _resetInactivityTimer();

      // Update last active provider
      if (context.mounted) {
        final appLastActiveNotifier = ProviderScope.containerOf(context)
            .read(appLastActiveProvider.notifier);
        appLastActiveNotifier.state = DateTime.now();
      }
    }
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_inactivityDuration, _handleInactivityTimeout);
  }

  void _handleInactivityTimeout() {
    // Navigate to lock screen due to inactivity
    if (context.mounted) {
      // Check if we're already on the PIN page to avoid navigation loops
      final currentRoute = GoRouterState.of(context).path ?? '';
      if (!currentRoute.contains(pAccessPin)) {
        // Navigate to PIN screen
        navkey.currentContext!.push(pAccessPin);
      }
    }
  }
}
