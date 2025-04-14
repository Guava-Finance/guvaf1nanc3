import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/styles/colors.dart';

ThemeData theme(BuildContext context) => ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: BrandColors.backgroundColor,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: BrandColors.backgroundColor,
      fontFamily: 'IBMPlexSans',
      textTheme: TextTheme(
        titleLarge: const TextStyle().copyWith(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'IBMPlexSans',
          letterSpacing: -0.02,
          height: 1.25,
        ),
        headlineLarge: TextStyle(
          color: BrandColors.textColor,
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'IBMPlexSans',
          letterSpacing: -0.02,
          height: 1.25,
        ),
        bodyMedium: TextStyle(
          color: BrandColors.textColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          fontFamily: 'IBMPlexSans',
          letterSpacing: -0.02,
          height: 1.25,
        ),
      ),
      primaryTextTheme: TextTheme(
        titleLarge: const TextStyle().copyWith(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'IBMPlexSans',
          letterSpacing: -0.02,
          height: 1.25,
        ),
        headlineLarge: TextStyle(
          color: BrandColors.textColor,
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'IBMPlexSans',
          letterSpacing: -0.02,
          height: 1.25,
        ),
      ),
    );
