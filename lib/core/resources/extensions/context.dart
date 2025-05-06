import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/notification/wrapper/notification.wrapper.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/main.dart';

extension CxtExtension on BuildContext {
  // theme related
  ThemeData get theme => Theme.of(this);
  AppBarTheme get appbarTheme => AppBarTheme.of(this);
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
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  EdgeInsets get padding => MediaQuery.of(this).padding;

  // navigator related
  NavigatorState get nav => Navigator.of(this);

  // focus scope
  FocusScopeNode get focusScope => FocusScope.of(this);

  // notification
  InAppNotificationWrapperState get notify => InAppNotificationWrapper.of(this);

  // view models

  Object get arg => ModalRoute.of(this)!.settings.arguments!;

  // MixPanel get mixpanel => sl<MixPanel>();

  bool get shouldLockDueToInactivity {
    final appLastActive =
        ProviderScope.containerOf(this).read(appLastActiveProvider);
    final inactiveTime = DateTime.now().difference(appLastActive);
    return inactiveTime.inMinutes >= APP_TIMEOUT_MINUTES;
  }

  void checkAndLockIfInactive() {
    if (shouldLockDueToInactivity) {
      // Navigate to PIN screen
      navkey.currentContext!.push(pAccessPin);
    }
  }
}

extension TextStylesExtension on BuildContext {
  TextStyle get brandRegular => Theme.of(this).textTheme.bodyMedium!.copyWith(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      );
}
