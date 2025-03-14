import 'package:flutter/material.dart';

mixin Loader<T extends StatefulWidget> on State<T> {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> withLoading(Future<void> Function() callback) async {
    isLoading.value = true;

    try {
      await callback.call();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    isLoading.dispose();

    super.dispose();
  }
}