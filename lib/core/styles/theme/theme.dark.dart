import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData themeDark(BuildContext context) => ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      primaryTextTheme: TextTheme(
        titleLarge: const TextStyle().copyWith(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'IBMPlexSans',
          letterSpacing: -0.02,
          height: 1.25,
        ),
      ),
    );
