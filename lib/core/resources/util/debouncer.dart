import 'dart:async';

import 'package:flutter/material.dart';

// Enhanced debouncer implementation
class Debouncer {
  final Duration duration;
  Timer? _timer;
  bool _disposed = false;

  Debouncer({required this.duration});

  void run(VoidCallback action) {
    if (_disposed) return;

    // Cancel any previous timer
    _timer?.cancel();

    // Set a new timer
    _timer = Timer(duration, () {
      if (!_disposed) {
        action();
      }
    });
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _timer = null;
  }
}
