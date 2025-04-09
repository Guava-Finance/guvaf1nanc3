import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/onboarding/presentation/notifier/onboard.notifier.dart';
import 'package:guava/features/onboarding/presentation/widgets/slide.dart';
import 'package:guava/widgets/custom_button.dart';

class Onboardingpage extends ConsumerStatefulWidget {
  const Onboardingpage({super.key});

  @override
  ConsumerState<Onboardingpage> createState() => _OnboardingpageState();
}

class _OnboardingpageState extends ConsumerState<Onboardingpage> {
  @override
  Widget build(BuildContext context) {
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
                        duration: Durations.medium3,
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
                  onPageChanged: (value) {
                    setState(() {
                      on.slideIndex = value;
                    });
                  },
                  children:
                      on.slides.map((e) => OnboardingSlide(e: e)).toList(),
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
