import 'package:flutter/material.dart';

class MyValueListener<T> extends StatelessWidget {
  const MyValueListener({
    super.key,
    required this.child,
    required this.value,
    required this.builder,
  });

  final Widget child;
  final ValueNotifier<T> value;
  final Widget Function(BuildContext, T, Widget?) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
        valueListenable: value,
        builder: builder,
        child: child,
    );
  }
}
