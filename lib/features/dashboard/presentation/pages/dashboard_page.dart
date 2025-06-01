import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/resources/util/connection_listener.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/pages/home_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref
    //       .read(firebaseAnalyticsProvider)
    //       .triggerScreenLogged(runtimeType.toString());

    //   context.mixpanel.track(MixpanelEvents.viewedDashboard);

    //   unawaited(performBackgroundChecks());

    //   Future.delayed(Durations.extralong4, () {
    //     ref
    //         .read(permissionManagerProvider)
    //         .requestCameraAndNotificationPermissions();
    //   });
    // });
  }

  Future<void> performBackgroundChecks() async {
    // checks to prefund and create USDC SPLtoken account behind the scenes
    // ref.read(dashboardNotifierProvider).initBalanceCheck();

    Future.delayed(Duration(seconds: 7), () {
      // triggers network connection listener
      ref.watch(connectivityStatusProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfig);

    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Container(color: BrandColors.washedYellow),
          Padding(
            padding: EdgeInsets.only(
              top: (config?.isMainnet ?? false) ? 0 : 5.h,
            ),
            child: Scaffold(body: HomePage()),
          ),
        ],
      ),
    );
  }
}
