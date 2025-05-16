import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/routes/router.dart';

final countdownProvider =
    StateNotifierProvider.family<CountdownNotifier, Duration, DateTime>(
  (ref, expiryDate) => CountdownNotifier(expiryDate),
);

class CountdownNotifier extends StateNotifier<Duration> {
  CountdownNotifier(DateTime expiry)
      : super(expiry.difference(DateTime.now())) {
    _startTimer(expiry);
  }

  void _startTimer(DateTime expiry) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = expiry.difference(DateTime.now());
      if (remaining.isNegative) {
        state = Duration.zero;
        timer.cancel();

        navkey.currentContext!.notify.addNotification(
          NotificationTile(
            content:
                '''Dynamic Account number has expired. Please don't make any transfer anymore''',
            notificationType: NotificationType.warning,
          ),
        );

        navkey.currentContext!.pop();
      } else {
        state = remaining;
      }
    });
  }
}
