import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/home/domain/usecases/check_username.dart';
import 'package:guava/features/home/domain/usecases/set_username.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home.notifier.g.dart';

final isBalanceVisibleProvider = StateProvider<bool>((ref) {
  return false;
});

final isUsernameAvailableProvider = StateProvider<bool?>((ref) {
  return null;
});

final avatarProvider = FutureProvider<String>((ref) async {
  final wallet = await ref.watch(solanaServiceProvider).walletAddress();
  // todo: download svg avatar to memory and pull from memory unless not found

  return wallet.avatar;
});

@riverpod
class HomeNotifier extends _$HomeNotifier with ChangeNotifier {
  @override
  HomeNotifier build() {
    return this;
  }

  Future<void> checkUsername(String username) async {
    final result =
        await ref.read(checkUsernameUsecaseProvider).call(params: username);

    if (result.isError) {
      ref.read(isUsernameAvailableProvider.notifier).state = null;

      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          title: 'Username check failed',
          content: result.errorMessage,
          notificationType: NotificationType.error,
        ),
      );
    } else {
      final data = (result as LoadedState).data;

      // error = true therefore username is not avaialable
      ref.read(isUsernameAvailableProvider.notifier).state =
          !(data['error'] == 'true');
    }
  }

  Future<bool> setUsername(String username) async {
    final result =
        await ref.read(setUsernameUsecaseProvider).call(params: username);

    if (result.isError) {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          title: 'Set Username failed',
          content: result.errorMessage,
          notificationType: NotificationType.error,
        ),
      );
    } else {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          content: (result as LoadedState).data['message'],
          notificationType: NotificationType.success,
        ),
      );
    }

    return !result.isError;
  }
}
