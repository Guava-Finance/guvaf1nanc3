import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/services/auth.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:pinput/pinput.dart';

class CustomNumberPad extends ConsumerWidget {
  const CustomNumberPad({
    required this.controller,
    this.isAmountPad = false,
    super.key,
  });

  final TextEditingController controller;
  final bool isAmountPad;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: List.generate(
            9,
            (i) => InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                controller.text += '${i + 1}';
              },
              child: Container(
                width: (context.mediaQuery.size.width * .30),
                height: (context.mediaQuery.size.width * .2),
                alignment: Alignment.center,
                child: Text(
                  '${i + 1}',
                  style: context.textTheme.headlineLarge?.copyWith(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isAmountPad) ...{
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final biometric = ref.read(biometricProvider);

                    return FutureBuilder(
                      future: biometric.isAppBiometricEnabled(),
                      builder: (_, ss) {
                        if (ss.data == null) return 0.verticalSpace;

                        return (ss.data!)
                            ? InkWell(
                                onTap: () async {
                                  HapticFeedback.mediumImpact();
                                  final result = await ref
                                      .read(biometricProvider)
                                      .authenticate();

                                  if (result) {
                                    navkey.currentContext!.pop(result);
                                  }
                                },
                                child: Container(
                                  width: (context.mediaQuery.size.width * .30),
                                  height: (context.mediaQuery.size.width * .2),
                                  alignment: Alignment.center,
                                  child: CustomIcon(
                                    icon: R.ASSETS_ICONS_BIOMETRIC_SVG,
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                ),
                              )
                            : 0.verticalSpace;
                      },
                    );
                  },
                ),
              ),
            } else ...{
              Expanded(
                child: InkWell(
                  onTap: () {
                    controller.text += '.';
                    HapticFeedback.mediumImpact();
                  },
                  child: Container(
                    width: (context.mediaQuery.size.width * .30),
                    height: (context.mediaQuery.size.width * .2),
                    alignment: Alignment.center,
                    child: Text(
                      '.',
                      style: context.textTheme.headlineLarge?.copyWith(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            },
            Expanded(
              child: InkWell(
                onTap: () {
                  controller.text += '0';
                  HapticFeedback.mediumImpact();
                },
                child: Container(
                  width: (context.mediaQuery.size.width * .30),
                  height: (context.mediaQuery.size.width * .2),
                  alignment: Alignment.center,
                  child: Text(
                    '0',
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  controller.delete();
                  HapticFeedback.mediumImpact();
                },
                child: Container(
                  width: (context.mediaQuery.size.width * .30),
                  height: (context.mediaQuery.size.width * .2),
                  alignment: Alignment.center,
                  child: CustomIcon(
                    icon: R.ASSETS_ICONS_CLEAR_SVG,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
