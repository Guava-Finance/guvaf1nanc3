import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/animated_icon.dart';

import 'dart:math' as math;

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    required this.e,
    super.key,
  });

  final dynamic e;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: AnimatedCustomIcon(
                    icon: e['background_icon'] as String,
                    width: double.infinity,
                    height: 330.h,
                    movementIntensity: 1.5, // Subtle movement
                    movementSpeed: 0.5, // Slow speed
                  ),
                ),
                ...(e['sub_icons_n_positions'] as List).map((e) {
                  // Randomize animation properties slightly for each icon
                  final random = math.Random();
                  final intensity =
                      1.0 + random.nextDouble() * 2.0; // Between 1.0 and 3.0
                  final speed =
                      0.3 + random.nextDouble() * 0.5; // Between 0.3 and 0.8

                  return Positioned(
                    left: e['ltrb'][0] as double?,
                    top: e['ltrb'][1] as double?,
                    right: e['ltrb'][2] as double?,
                    bottom: e['ltrb'][3] as double?,
                    child: AnimatedCustomIcon(
                      icon: e['icon'] as String,
                      movementIntensity: intensity,
                      movementSpeed: speed,
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
    );
  }
}
