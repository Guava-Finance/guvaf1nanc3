import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/dashboard/presentation/pages/loader.dart';
import 'package:guava/features/onboarding/presentation/notifier/onboard.notifier.dart';
import 'package:guava/features/onboarding/presentation/widgets/slide.dart';
import 'package:guava/widgets/custom_button.dart';

class Onboardingpage extends ConsumerStatefulWidget {
  const Onboardingpage({super.key});

  @override
  ConsumerState<Onboardingpage> createState() => _OnboardingpageState();
}

class _OnboardingpageState extends ConsumerState<Onboardingpage>
    with SingleTickerProviderStateMixin {
  late final PageController controller;

  Timer? _autoScrollTimer;
  bool _isForward = true;

  @override
  initState() {
    controller = PageController();
    super.initState();

    // Start auto-scrolling with a delay to allow UI to build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    // Set a timer that triggers every 3 seconds
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      final on = ref.read(onboardingNotifierProvider);

      if (_isForward) {
        // Moving forward
        if (on.slideIndex < on.slides.length - 1) {
          controller.animateToPage(
            on.slideIndex + 1,
            duration: Durations.long2,
            curve: Curves.linear,
          );
        } else {
          // Reached the end, change direction
          _isForward = false;
          controller.animateToPage(
            on.slideIndex - 1,
            duration: Durations.long2,
            curve: Curves.linear,
          );
        }
      } else {
        // Moving backward
        if (on.slideIndex > 0) {
          controller.animateToPage(
            on.slideIndex - 1,
            duration: Durations.long2,
            curve: Curves.linear,
          );
        } else {
          // Reached the beginning, change direction
          _isForward = true;
          controller.animateToPage(
            on.slideIndex + 1,
            duration: Durations.long2,
            curve: Curves.linear,
          );
        }
      }
    });
  }

  bool iAgree = false;

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
                    for (var i = 0; i < on.slides.length; i++) ...{
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
                    },
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Cancel the current timer
                    _autoScrollTimer?.cancel();
                    // Restart the timer after user interaction
                    _startAutoScroll();
                  },
                  onPanDown: (_) {
                    // Cancel auto-scrolling when user starts to manually scroll
                    _autoScrollTimer?.cancel();
                  },
                  onPanEnd: (_) {
                    // Restart auto-scrolling after user
                    // finishes manual scrolling
                    _startAutoScroll();
                  },
                  child: PageView(
                    controller: controller,
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: (value) {
                      setState(() {
                        on.slideIndex = value;
                      });
                    },
                    children:
                        on.slides.map((e) => OnboardingSlide(e: e)).toList(),
                  ),
                ),
              ),
              24.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        iAgree = !iAgree;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: Durations.short1,
                          width: 18.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                            color: iAgree ? BrandColors.primary : null,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: BrandColors.textColor,
                              width: 1.w,
                            ),
                          ),
                          child: iAgree
                              ? Icon(
                                  Icons.check,
                                  size: 12.sp,
                                  color: BrandColors.backgroundColor,
                                  weight: 5.w,
                                )
                              : null,
                        ),
                        6.horizontalSpace,
                        Text.rich(
                          TextSpan(
                            text: 'I agree to the ',
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: context.medium.copyWith(
                                  color: BrandColors.barGreen,
                                ),
                              )
                            ],
                            style: context.medium.copyWith(
                              color: BrandColors.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  12.verticalSpace,
                  CustomButton(
                    disable: !iAgree,
                    onTap: () {
                      context.nav.push(
                        MaterialPageRoute(
                          builder: (_) => FullScreenLoader(
                            onLoading: () async {
                              await Future.delayed(Durations.long4);
                              await on.createAWallet();
                              await Future.delayed(Durations.long4);
                            },
                            onSuccess: () async {
                              // setup access code after creating wallet
                              navkey.currentContext!.go(pSetupPin);
                            },
                            onError: () {
                              context.pop();
                            },
                            subMessages: [
                              'Initializing wallet creation...',
                              'Generating secure wallet keys...',
                              'Encrypting private credentials...',
                              'Saving wallet securely to device...',
                              'Enabling gasless transaction support...',
                              'Verifying USDC token account...',
                              'Enabling USDC support if needed...',
                              'Finalizing wallet setup...',
                            ],
                            title: 'Please wait...',
                          ),
                        ),
                      );
                    },
                    title: 'Create a new wallet',
                  ),
                  12.verticalSpace,
                  Center(
                    child: TextButton(
                      onPressed: iAgree
                          ? () {
                              context.push(pAddConnectWallet);
                            }
                          : null,
                      child: Text(
                        'I already have a wallet',
                        style: context.medium.copyWith(
                          fontSize: 14.sp,
                          color: iAgree
                              ? BrandColors.textColor
                              : BrandColors.washedTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ).padHorizontal,
              10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
