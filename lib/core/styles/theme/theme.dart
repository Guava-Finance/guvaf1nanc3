import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/styles/colors.dart';

ThemeData theme(BuildContext context) => ThemeData(
      // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      colorScheme: ColorScheme.fromSeed(
        seedColor: BrandColors.backgroundColor,
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: BrandColors.backgroundColor,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: BrandColors.textColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'IBMPlexSans',
          letterSpacing: -0.02,
          height: 1.25,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
