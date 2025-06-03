import 'dart:async';
import 'dart:isolate';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/analytics/firebase/analytics.dart';
import 'package:guava/core/resources/analytics/mixpanel/const.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/notification/wrapper/blur.dart';
import 'package:guava/core/resources/services/pubnub.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/core/styles/theme/theme.dart';
import 'package:guava/firebase_options.dart';

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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final wallet = await ref.read(walletAddressProvider.future);
      final analytics = ref.read(firebaseAnalyticsProvider);

      await navkey.currentContext!.mixpanel.init();
      await analytics.init();
      await analytics.triggerAppOpened(parameters: {
        'wallet_address': wallet,
      });
      await analytics.setUserProperty(wallet, wallet);

      navkey.currentContext!.mixpanel.identify(wallet);
      navkey.currentContext!.mixpanel.setSuperProp(wallet);

      navkey.currentContext!.mixpanel.track(MixpanelEvents.appOpened);
    });
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle initial URI if app was opened from a link
    final uri = await _appLinks.getInitialLink();
    if (uri != null) {
      _handleDeepLink(uri);
    }

    // Listen for incoming links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    if (uri.path == '/pay') {
      // Handle payment link
      final payload = uri.queryParameters;

      if (payload.containsKey('id')) {
        final id = Uri.decodeComponent(payload['id'] as String);

        // esure the user is logged in before navigating & has an active wallet
        navkey.currentContext?.push(pGuavaPayDisclaimer, extra: id);
      }
    }
  }

  void inAppMessagingListener() {}

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, snapshot) {
        return MaterialApp.router(
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
              child: BlurWrapper(child: child!),
            );
          },
        );
      },
    );
  }
}
