import 'package:flutter/material.dart';
import 'package:guava/core/resources/notification/wrapper/notification.wrapper.dart';

extension CxtExtension on BuildContext {
  // theme related
  ThemeData get theme => Theme.of(this);
  AppBarTheme get appbarTheme => AppBarTheme.of(this);
  DialogThemeData get dialogTheme => DialogTheme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  TabBarThemeData get tabbarTheme => Theme.of(this).tabBarTheme;

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
