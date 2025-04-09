import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/notification/wrapper/notification.wrapper.dart';

extension CxtExtension on BuildContext {
  // theme related
  ThemeData get theme => Theme.of(this);
  AppBarTheme get appbarTheme => AppBarTheme.of(this);
  DialogThemeData get dialogTheme => DialogTheme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  TabBarThemeData get tabbarTheme => Theme.of(this).tabBarTheme;

  // text-styles related
  TextStyle get regular => textTheme.bodyMedium!.copyWith(
        fontSize: 12.sp,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      );
  TextStyle get medium => textTheme.bodyMedium!.copyWith(
      fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w500);

  TextStyle get semiBold => textTheme.bodyMedium!.copyWith(
        fontSize: 32.sp,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      );

  TextStyle get bold => textTheme.bodyMedium!.copyWith(
        fontSize: 12.sp,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );

  TextStyle get extraBold => textTheme.bodyMedium!.copyWith(
        fontSize: 12.sp,
        color: Colors.white,
        fontWeight: FontWeight.w900,
      );

  // size related
  Size get size => MediaQuery.of(this).size;
  EdgeInsets get padding => MediaQuery.of(this).padding;

  // navigator related
  NavigatorState get nav => Navigator.of(this);

  // focus scope
  FocusScopeNode get focusScope => FocusScope.of(this);

  // notification
  InAppNotificationWrapperState get notify => InAppNotificationWrapper.of(this);

  // view models

  Object get arg => ModalRoute.of(this)!.settings.arguments!;
}

extension TextStylesExtension on BuildContext {
  TextStyle get brandRegular => Theme.of(this).textTheme.bodyMedium!.copyWith(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      );
}
