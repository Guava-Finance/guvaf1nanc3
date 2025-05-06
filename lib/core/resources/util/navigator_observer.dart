import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appCurrentRoute = StateProvider<String>((ref) => '');

class RouteObserverImpl extends RouteObserver<PageRoute<dynamic>> {
  String? currentRouteName;

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is PageRoute) {
      currentRouteName = route.settings.name;
    }

    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute is PageRoute) {
      currentRouteName = previousRoute.settings.name;
    }
    super.didPop(route, previousRoute);
  }
}
