import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:pinput/pinput.dart';

class CustomNumberPad extends StatelessWidget {
  const CustomNumberPad({
    required this.controller,
    this.isAmountPad = false,
    super.key,
  });

  final TextEditingController controller;
  final bool isAmountPad;

  @override
  Widget build(BuildContext context) {
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
                child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
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
