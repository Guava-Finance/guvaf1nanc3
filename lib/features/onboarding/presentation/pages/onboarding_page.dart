import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/app_core.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/onboarding/presentation/notifier/onboard.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/utility_widget.dart';

class Onboardingpage extends ConsumerWidget {
  const Onboardingpage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(onboardingNotifierProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.verticalSpace,
              SizedBox(
                height: 35.h,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < on.slides.length; i++)
                      AnimatedContainer(
                        width: i == on.slideIndex ? 24.w : 4.w,
                        height: 4.h,
                        duration: Durations.medium4,
                        margin: EdgeInsets.only(
                          right: 2.w,
                          left: 2.w,
                        ),
                        decoration: BoxDecoration(
                          color: i == on.slideIndex
                              ? BrandColors.textColor
                              : BrandColors.disabledTextColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  onPageChanged: (value) => on.slideIndex = value,
                  children: on.slides
                      .map((e) => Container(
                            margin: EdgeInsets.only(right: 3.w),
                            child: Column(
                              children: [
                                Text(
                                  e['title'] as String,
                                  style: context.textTheme.headlineLarge,
                                ),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Align(
                                        child: CustomIcon(
                                          icon: e['background_icon'] as String,
                                        ),
                                      ),
                                      ...(e['sub_icons_n_positions'] as List)
                                          .map((e) {
                                        return Positioned(
                                          left: e['ltrb'][0] as double?,
                                          top: e['ltrb'][1] as double?,
                                          right: e['ltrb'][2] as double?,
                                          bottom: e['ltrb'][3] as double?,
                                          child: CustomIcon(
                                            icon: e['icon'] as String,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                Text(
                                  e['subtitle'] as String,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: BrandColors.washedTextColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              24.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: false,
                          onChanged: (value) {},
                          activeColor: Colors.white,
                          fillColor: WidgetStateProperty.all(Colors.white),
                        ),
                        Text(
                          'I agree to the Terms of Service',
                          style: context.medium.copyWith(
                            color: BrandColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    CustomButton(
                      onTap: () {},
                      title: 'Create a new wallet',
                    ),
                    SizedBox(height: 5.h),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'I already have a wallet',
                          style: context.medium.copyWith(
                            fontSize: 14.sp,
                            color: BrandColors.textColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
