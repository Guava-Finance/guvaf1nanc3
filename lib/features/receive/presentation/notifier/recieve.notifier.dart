import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/receive/domain/entities/account_payable.dart';
import 'package:guava/features/receive/domain/usecases/make_a_deposit.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recieve.notifier.g.dart';

final activeReceiveTabState = StateProvider<int>((ref) {
  return 0;
});

final depositAmount = StateProvider<double>((ref) => 0.0);

final accountPayable = StateProvider<AccountPayable?>((ref) => null);

@riverpod
class RecieveNotifier extends _$RecieveNotifier {
  @override
  RecieveNotifier build() {
    pageController = PageController(
      initialPage: ref.watch(activeReceiveTabState),
    );

    ref.onDispose(() => pageController.dispose());
    return this;
  }

  late PageController pageController;

  void jumpTo(int page) {
    pageController.jumpToPage(page);
    ref.watch(activeReceiveTabState.notifier).state = page;
  }

  Future<bool> initDeposit() async {
    final amount = ref.watch(localAountTransfer);

    final result = await ref.watch(makeADepositProvider).call(params: amount);

    if (result.isError) {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          content: result.errorMessage,
          notificationType: NotificationType.error,
        ),
      );

      return false;
    } else {
      ref.watch(accountPayable.notifier).state =
          (result as LoadedState<AccountPayable>).data;
      return true;
    }
  }
}
