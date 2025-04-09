import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/widgets/utility_widget.dart';

ThemeData themeDark(BuildContext context) => ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      scaffoldBackgroundColor: hexColor('#28443F'),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.red,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.light),
        color: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
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
      ),
    );
