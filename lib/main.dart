
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/notification/wrapper/blur.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/theme/theme.dart';
import 'package:guava/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // /// Init Firebase setup
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // /// Only collect Crashlytics once the app is in release mode
  // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
  //   kReleaseMode,
  // );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
