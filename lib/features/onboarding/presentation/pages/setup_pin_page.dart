import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/app_core.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/services/auth.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/onboarding/presentation/notifier/onboard.notifier.dart';
import 'package:guava/features/onboarding/presentation/widgets/number_pad.dart';
import 'package:pinput/pinput.dart';

class SetupPinPage extends ConsumerStatefulWidget {
  const SetupPinPage({
    this.onComplete,
    this.subtitle,
    this.title,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final Function(String)? onComplete;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SetupPinPageState();
}

class _SetupPinPageState extends ConsumerState<SetupPinPage> {
  late final TextEditingController pinCtrl;
  late final TextEditingController confirmPinCtrl;

  bool isConfirmingPin = false;

  @override
  void initState() {
    pinCtrl = TextEditingController();
    confirmPinCtrl = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    pinCtrl.dispose();
    confirmPinCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final on = ref.read(onboardingNotifierProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          24.verticalSpace,
          Text(
            isConfirmingPin ? 'Confirm your Pin' : 'Set up your PIN',
            style: context.textTheme.bodyLarge?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: BrandColors.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          Text(
            widget.subtitle ??
                'PIN adds an extra layer of security when\nusing the app',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: BrandColors.washedTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          48.verticalSpace,
          Pinput(
            controller: isConfirmingPin ? confirmPinCtrl : pinCtrl,
            length: 6,
            readOnly: true,
            pinAnimationType: PinAnimationType.scale,
            obscuringWidget: Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BrandColors.primary,
              ),
            ),
            showCursor: false,
            obscureText: true,
            defaultPinTheme: PinTheme(
              textStyle: context.textTheme.headlineLarge,
              height: 20.h,
              width: 20.w,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BrandColors.darkD9,
              ),
            ),
            onCompleted: (value) async {
              if (isConfirmingPin) {
                if (pinCtrl.text != confirmPinCtrl.text) {
                  setState(() => isConfirmingPin = false);

                  pinCtrl.clear();
                  confirmPinCtrl.clear();

                  context.notify.addNotification(
                    NotificationTile(
                      content: 'Pin mismatch. Please try again',
                      notificationType: NotificationType.error,
                    ),
                  );
                } else {
                  await on.savedAccessPin(value);
                  setupBiometric();
                }
                // submit pin
              } else {
                setState(() => isConfirmingPin = true);

                navkey.currentContext!.notify.addNotification(
                  NotificationTile(
                    content: 'Confirm your pin. Re-enter your pin',
                  ),
                );
              }
            },
          ),
          24.verticalSpace,
          Spacer(),
          CustomNumberPad(
            controller: isConfirmingPin ? confirmPinCtrl : pinCtrl,
          ),
          40.verticalSpace,
        ],
      ).padHorizontal,
    );
  }

  void setupBiometric() {
    Future.microtask(() async {
      if (mounted) {
        final auth = ref.read(biometricProvider);

        if ((await auth.hasDeviceSupport()) &&
            (await auth.isDeviceBiometricEnabled())) {
          final result = await auth.authenticate();

          if (result) {
            unawaited(_biometricEnabled());
            navkey.currentContext!.toPath(pDashboard);
          } else {
            navkey.currentContext!.toPath(pDashboard);
            navkey.currentContext!.notify.addNotification(
              NotificationTile(
                content: 'Failed to setup biometric.',
                notificationType: NotificationType.error,
              ),
            );
          }
        }
      }
    });
  }

  Future<void> _biometricEnabled() async {
    await ref.read(securedStorageServiceProvider).writeToStorage(
          key: Strings.biometric,
          value: DateTime.now().toIso8601String(),
        );
  }
}
