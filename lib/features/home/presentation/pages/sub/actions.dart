import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/features/home/presentation/widgets/action_banner.dart';

class ActionTasks extends ConsumerStatefulWidget {
  const ActionTasks({
    super.key,
  });

  @override
  ConsumerState<ActionTasks> createState() => _ActionTasksState();
}

class _ActionTasksState extends ConsumerState<ActionTasks> {
  late final PageController controller;

  Timer? _autoScrollTimer;
  bool _isForward = true;

  @override
  initState() {
    controller = PageController(viewportFraction: 0.9);
    super.initState();

    // Start auto-scrolling with a delay to allow UI to build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // final hasBackedUp = await ref.read(userHasBackedUpPhrase.future);

      _startAutoScroll();

      // if (hasBackedUp) {
      //   widgetActions.removeAt(1);
      //   setState(() {});
      // }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    // Set a timer that triggers every 3 seconds
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      int ca = ref.read(currentAction);

      if (_isForward) {
        // Moving forward
        if (ca < widgetActions.length - 1) {
          controller.animateToPage(
            ca + 1,
            duration: Durations.long2,
            curve: Curves.linear,
          );
        } else {
          // Reached the end, change direction
          _isForward = false;
          controller.animateToPage(
            ca - 1,
            duration: Durations.long2,
            curve: Curves.linear,
          );
        }
      } else {
        // Moving backward
        if (ca > 0) {
          controller.animateToPage(
            ca - 1,
            duration: Durations.long2,
            curve: Curves.linear,
          );
        } else {
          // Reached the beginning, change direction
          _isForward = true;
          controller.animateToPage(
            ca + 1,
            duration: Durations.long2,
            curve: Curves.linear,
          );
        }
      }
    });
  }

  List<Widget> widgetActions = [
    ActionBanners(
      title: 'KYC Verification',
      subtitle: 'Unlock more access',
      bannerKey: Strings.kycVerification,
      icon: R.ASSETS_ICONS_KYC_ICON_SVG,
      onTap: () {
        navkey.currentContext!.push(pKyc);
        HapticFeedback.lightImpact();
      },
    ),
    ActionBanners(
      title: 'Back up your 12/24 Key-phrase!',
      subtitle: 'Learn more',
      bannerKey: Strings.backupPhrase,
      icon: R.ASSETS_ICONS_SECURITY_LOCK_SVG,
      onTap: () {
        // true: means backup seed phrase
        // false: means just see seed phrase
        navkey.currentContext!.push(pMnenomicInstruction, extra: true);
        HapticFeedback.lightImpact();
      },
    ),
    ActionBanners(
      title: 'Create your @username',
      subtitle: 'A unique identity for your wallet',
      bannerKey: Strings.createUsername,
      icon: R.ASSETS_ICONS_USERNAME_ICON_SVG,
      onTap: () {
        navkey.currentContext!.push(pSetUsername);
        HapticFeedback.lightImpact();
      },
    ),
    ActionBanners(
      title: 'Connect your wallet',
      subtitle: 'Unlock full functionality',
      icon: R.ASSETS_ICONS_WALLET_CONNECT_ICON_SVG,
      bannerKey: Strings.connectWallet,
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return widgetActions.isEmpty
        ? 0.verticalSpace
        : SizedBox(
            height: 90.h,
            child: PageView(
              onPageChanged: (value) {
                ref.read(currentAction.notifier).state = value;
              },
              controller: controller,
              children: widgetActions,
            ),
          );
  }
}
