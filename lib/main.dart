import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/core/styles/theme/theme.dart';
import 'package:guava/firebase_options.dart';

import 'core/resources/notification/wrapper/notification.wrapper.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: BrandColors.scaffoldColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    // await configureDependencies();

    /// Init Firebase setup
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Only collect Crashlytics once the app is in release mode
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      kReleaseMode,
    );

    if (kDebugMode) {
      debugRepaintRainbowEnabled = false;
    }

    runApp(const ProviderScope(child: MyApp()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));

  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);
}

final appStateProvider = StateProvider<AppLifecycleState>((ref) {
  return AppLifecycleState.resumed;
});

// Create provider for tracking app inactivity
final appLastActiveProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

const int APP_TIMEOUT_MINUTES = 1;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DateTime? _lastResumeTime;
  DateTime? _lastPausedTime;

  @override
  void initState() {
    super.initState();
    // Register the observer to listen for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
    _lastResumeTime = DateTime.now();
  }

  @override
  void dispose() {
    // Important: Remove the observer when the widget is disposed
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
          navkey.currentContext!.push(pAccessPin, extra: true);

          // // App is visible and responding to user input
          // _lastResumeTime = DateTime.now();
          // appLastActiveNotifier.state = _lastResumeTime!;

          // // Check if we need to lock the app due to inactivity
          // if (_lastPausedTime != null) {
          //   final inactivityDuration =
          //       _lastResumeTime!.difference(_lastPausedTime!);
          //   if (inactivityDuration.inMinutes >= APP_TIMEOUT_MINUTES) {
          //     // Lock the app and navigate to pin screen
          //     _handleAppTimeout();
          //   }
          // }
          break;

        case AppLifecycleState.inactive:
          // App is inactive, might be transitioning between states
          break;

        case AppLifecycleState.paused:
          // App is not visible, in the background
          _lastPausedTime = DateTime.now();
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

  // void _handleAppTimeout() {
  //   // Navigate to PIN screen when app times out
  //   // We use a slight delay to ensure the app is fully resumed
  //   Future.delayed(const Duration(milliseconds: 300), () {
  //     if (navkey.currentContext != null) {
  //       // Check if we're already on the PIN page to avoid navigation loops
  //       final currentRoute =
  //           GoRouter.of(navkey.currentContext!).state.name ?? '';
  //       // GoRouterState.of(navkey.currentContext!).name ?? '';
  //       if (!currentRoute.contains(pAccessPin.pathToName)) {
  //         // sends true because isPhoneLock is default to false
  //         navkey.currentContext!.push(pAccessPin, extra: true);
  //       }
  //     }
  //   });
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            context.focusScope.unfocus();

            // Update last active time when user interacts with app
            if (context.mounted) {
              final appLastActiveNotifier = ProviderScope.containerOf(context)
                  .read(appLastActiveProvider.notifier);
              appLastActiveNotifier.state = DateTime.now();
            }
          },
          child: MaterialApp.router(
            title: 'Guava Finance',
            theme: theme(context),
            debugShowCheckedModeBanner: false,
            // darkTheme: themeDark(context),
            routerConfig: router,
            builder: (context, child) {
              final MediaQueryData mediaQuery = MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1),
              );
              return MediaQuery(
                data: mediaQuery,
                child: Consumer(builder: (context, ref, _) {
                  // Monitor app lifecycle in the builder
                  // ref.listen(appStateProvider, (previous, current) {
                  //   debugPrint('App state changed: $previous -> $current');

                  //   // Add any global app state reactions here
                  //   if (previous == AppLifecycleState.paused &&
                  //       current == AppLifecycleState.resumed) {
                  //     // App returned from background
                  //     final lastActive = ref.read(appLastActiveProvider);
                  //     final inactiveTime =
                  //         DateTime.now().difference(lastActive);

                  //     if (inactiveTime.inMinutes >= APP_TIMEOUT_MINUTES) {
                  //       _handleAppTimeout();
                  //     }
                  //   }
                  // });

                  return InAppNotificationWrapper(child: child!);
                }),
              );
            },
          ),
        );
      },
    );
  }
}
