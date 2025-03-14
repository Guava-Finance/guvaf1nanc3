import 'package:flutter/material.dart';

class MyValueListener<T> extends StatelessWidget {
  const MyValueListener({
    required this.child,
    required this.value,
    required this.builder,
    super.key,
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
