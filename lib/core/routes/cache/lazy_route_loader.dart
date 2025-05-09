import 'package:flutter/cupertino.dart';

/// Helper class for lazy loading routes and widgets
class LazyRouteLoader {
  /// Lazy load a widget with a loading indicator
  static Widget lazyLoad(WidgetBuilder builder) {
    return FutureBuilder(
      future: Future.delayed(
        const Duration(
          milliseconds: 10,
        ),
      ), // Small delay for smooth transition
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return builder(context);
        }

        return const Center(child: CupertinoActivityIndicator());
      },
    );
  }

  /// Prefetch a widget to have it ready before navigation
  static Future<void> prefetch(BuildContext context, Widget widget) async {
    // Preload the widget by creating it but not mounting it yet
    await precacheWidgetTree(context, widget);
  }

  /// Precache a widget tree
  static Future<void> precacheWidgetTree(
    BuildContext context,
    Widget widget,
  ) async {
    // ignore: invalid_use_of_protected_member
    final element = widget.createElement();
    // This will trigger any lazy loading within the widget
    element.mount(null, null);
    await Future.delayed(const Duration(milliseconds: 10));
    element.unmount();
  }
}
