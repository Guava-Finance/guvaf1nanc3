import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/transfer/data/models/params/bank_transfer.dart';
import 'package:guava/features/transfer/data/models/params/wallet_transfer.dart';
import 'package:guava/features/transfer/domain/entities/account_detail.dart';
import 'package:guava/features/transfer/domain/usecases/bank_transfer.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_account.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_address.dart';
import 'package:guava/features/transfer/domain/usecases/wallet_transfer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transfer.notifier.g.dart';

final activeTabState = StateProvider<int>((ref) {
  return 0;
});

final accountDetail = StateProvider<AccountDetail?>((ref) {
  return null;
});

final localAountTransfer = StateProvider<double>((ref) => 0.0);
final usdcAountTransfer = StateProvider<double>((ref) => 0.0);
final transferPurpose = StateProvider<String>((ref) => '');

@riverpod
class TransferNotifier extends _$TransferNotifier with ChangeNotifier {
  @override
  TransferNotifier build() {
    pageController = PageController(
      initialPage: ref.read(activeTabState.notifier).state,
    );

    ref.onDispose(() => pageController.dispose());
    return this;
  }

  late PageController pageController;

  void jumpTo(int page) {
    pageController.jumpToPage(page);
  }

  Future<void> resolveAddress(String address) async {
    await ref.read(resolveAddressUsecaseProvider).call(params: address);
  }

  Map<String, dynamic> accountResolutionData = {};

  Future<void> resolveAccount() async {
    final result = await ref.read(resolveAccountUsecaseProvider).call(
          params: accountResolutionData,
        );

    if (result.isError) {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          content: result.errorMessage,
          notificationType: NotificationType.error,
        ),
      );
    } else {
      ref.watch(accountDetail.notifier).state =
          (result as LoadedState<AccountDetail>).data;

      notifyListeners();
    }
  }

  Map<String, dynamic> bankTransferData = {};

  Future<void> makeABankTransfer() async {
    final result = await ref.read(bankTransferUsecaseProvider).call(
          params: BankTransferParam.fromJson(bankTransferData),
        );

    if (result.isError) {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          content: result.errorMessage,
          notificationType: NotificationType.error,
        ),
      );
    } else {
      AppLogger.log((result as LoadedState).data);
    }
  }

  Map<String, dynamic> walletTransferData = {};

  Future<bool> makeWalletTransfer() async {
    walletTransferData['recipient_address'] =
        ref.read(receipentAddressProvider.notifier).state;
    walletTransferData['amount'] =
        ref.read(localAountTransfer.notifier).state.toString();
    walletTransferData['usdcAmount'] =
        ref.read(usdcAountTransfer.notifier).state.toString();

    final result = await ref.read(wallTransferUsecaseProvider).call(
          params: WalletTransferParam.fromJson(walletTransferData),
        );

    if (result.isError) {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          content: result.errorMessage,
          notificationType: NotificationType.error,
        ),
      );

      return false;
    } else {
      AppLogger.log((result as LoadedState).data);

      return true;
    }
  }
}
