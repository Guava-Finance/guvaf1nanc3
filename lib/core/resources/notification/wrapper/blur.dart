import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/resources/notification/wrapper/notification.wrapper.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';

final appStateProvider = StateProvider<AppLifecycleState>((ref) {
  return AppLifecycleState.resumed;
});

// Create provider for tracking app inactivity
final appLastActiveProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// ignore: constant_identifier_names
const int APP_TIMEOUT_MINUTES = 2;

class BlurWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const BlurWrapper({
    required this.child,
    super.key,
  });

  @override
  BlurWrapperState createState() => BlurWrapperState();
}

class BlurWrapperState extends ConsumerState<BlurWrapper>
    with WidgetsBindingObserver {
  bool shouldBlur = false;

  DateTime? _lastResumeTime;
  DateTime? _lastPausedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lastResumeTime = DateTime.now();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Update our provider with the current lifecycle state
    if (context.mounted) {
      // Using context.read() because we're in a callback
      final appStateNotifier =
          ProviderScope.containerOf(context).read(appStateProvider.notifier);
      appStateNotifier.state = state;

      final appLastActiveNotifier = ProviderScope.containerOf(context)
          .read(appLastActiveProvider.notifier);

      switch (state) {
        case AppLifecycleState.resumed:
          setState(() {
            shouldBlur = false;
          });

          // App is visible and responding to user input
          _lastResumeTime = DateTime.now();
          appLastActiveNotifier.state = _lastResumeTime!;

          // Check if we need to lock the app due to inactivity
          if (_lastPausedTime != null) {
            final inactivityDuration =
                _lastResumeTime!.difference(_lastPausedTime!);
            if (inactivityDuration.inMinutes >= APP_TIMEOUT_MINUTES) {
              // Lock the app and navigate to pin screen
              _handleAppTimeout();
            }
          }
          break;

        case AppLifecycleState.inactive:
          // App is inactive, might be transitioning between states
          setState(() {
            shouldBlur = true;
          });
          break;

        case AppLifecycleState.paused:
          // App is not visible, in the background
          _lastPausedTime = DateTime.now();
          setState(() {
            shouldBlur = true;
          });
          break;

        case AppLifecycleState.detached:
          // App is in a "detached" state - may be terminated
          break;

        case AppLifecycleState.hidden:
          // App is hidden (iOS specific)
          break;
      }
    }
  }

  void _handleAppTimeout() {
    // Navigate to PIN screen when app times out
    // We use a slight delay to ensure the app is fully resumed
    Future.delayed(const Duration(milliseconds: 200), () {
      if (navkey.currentContext != null) {
        // Check if we're already on the PIN page to avoid navigation loops
        final currentRoute =
            GoRouter.of(navkey.currentContext!).state.name ?? '';
        if (!currentRoute.contains(pAccessPin.pathToName) &&
            !currentRoute.contains(pSetupPin.pathToName) &&
            !currentRoute.contains(pOnboarding.pathToName)) {
          navkey.currentContext!.push(pAccessPin, extra: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // this disposes keyboard on tap of anywhere outside keyboard or textfield
    return GestureDetector(
      onTap: () {
        navkey.currentContext!.focusScope.unfocus();

        // Update last active time when user interacts with app
        if (context.mounted) {
          final appLastActiveNotifier = ProviderScope.containerOf(context)
              .read(appLastActiveProvider.notifier);
          appLastActiveNotifier.state = DateTime.now();
        }
      },
      child: Consumer(
        builder: (context, ref, child) {
          // Monitor app lifecycle in the builder
          ref.listen(appStateProvider, (previous, current) {
            // Add any global app state reactions here
            if (previous == AppLifecycleState.paused &&
                current == AppLifecycleState.resumed) {
              // App returned from background
              final lastActive = ref.read(appLastActiveProvider);
              final inactiveTime = DateTime.now().difference(lastActive);

              if (inactiveTime.inMinutes >= APP_TIMEOUT_MINUTES) {
                _handleAppTimeout();
              }
            }
          });

          return Stack(
            children: [
              InAppNotificationWrapper(child: widget.child),
              if (shouldBlur) ...{
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    height: double.maxFinite,
                    width: double.infinity,
                    color: BrandColors.backgroundColor.withValues(alpha: .8),
                  ),
                ),
              },
            ],
          );
        },
      ),
    );
  }
}
