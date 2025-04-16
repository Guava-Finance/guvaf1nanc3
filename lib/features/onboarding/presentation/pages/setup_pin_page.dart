import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/onboarding/presentation/widgets/number_pad.dart';
import 'package:guava/widgets/app_icon.dart';
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

  @override
  void initState() {
    pinCtrl = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          24.verticalSpace,
          Text(
            widget.title ?? 'Enter PIN',
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
            controller: pinCtrl,
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
            onCompleted: (value) {
              widget.onComplete?.call(value);
            },
          ),
          24.verticalSpace,
          Spacer(),
          CustomNumberPad(
            controller: pinCtrl,
          ),
          40.verticalSpace,
        ],
      ).padHorizontal,
    );
  }
}
