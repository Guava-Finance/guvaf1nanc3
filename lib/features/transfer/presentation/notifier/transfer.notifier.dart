import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/mixpanel/const.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/transfer/data/models/params/bank_transfer.dart';
import 'package:guava/features/transfer/data/models/params/wallet_transfer.dart';
import 'package:guava/features/transfer/domain/entities/account_detail.dart';
import 'package:guava/features/transfer/domain/entities/purpose.dart';
import 'package:guava/features/transfer/domain/usecases/bank_transfer.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_account.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_address.dart';
import 'package:guava/features/transfer/domain/usecases/save_to_address_book.dart';
import 'package:guava/features/transfer/domain/usecases/solana_pay.dart';
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

final transactionId = StateProvider<String>((ref) => '');
final addressLabel = StateProvider<String>((ref) => '');

final selectedPurpose = StateProvider<TransferPurpose?>((ref) => null);

@riverpod
class TransferNotifier extends _$TransferNotifier with ChangeNotifier {
  @override
  TransferNotifier build() {
    pageController = PageController(
      initialPage: ref.watch(activeTabState),
    );

    ref.onDispose(() => pageController.dispose());
    return this;
  }

  late PageController pageController;

  void jumpTo(int page) {
    pageController.jumpToPage(page);
    ref.watch(activeTabState.notifier).state = page;
  }

  Future<bool> hasShowcasedTransfer() async {
    return ref
        .watch(securedStorageServiceProvider)
        .doesExistInStorage(Strings.transferShowcase);
  }

  Future<void> hasShowcased() async {
    await ref.watch(securedStorageServiceProvider).writeToStorage(
          key: Strings.transferShowcase,
          value: DateTime.now().toIso8601String(),
        );
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

  Future<bool> makeABankTransfer() async {
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

      return false;
    } else {
      ref.read(transactionId.notifier).state =
          (result as LoadedState).data['transaction_id'];

      return true;
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

    // send event to mixpanel
    if (ref.watch(isUsingUsername)) {
      navkey.currentContext!.mixpanel.track(MixpanelEvents.sendViaUsername);
    } else {
      navkey.currentContext!.mixpanel.track(MixpanelEvents.sendViaWallet);
    }

    if (result.isError) {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          content: result.errorMessage,
          notificationType: NotificationType.error,
        ),
      );

      navkey.currentContext!.mixpanel.track(MixpanelEvents.transactionFailed);

      return false;
    } else {
      navkey.currentContext!.mixpanel.track(MixpanelEvents.transactionSuccess);

      ref.read(transactionId.notifier).state =
          (result as LoadedState<Map<String, dynamic>>).data['transaction_id'];

      return true;
    }
  }

  Future<bool> saveToAddressBook() async {
    final result = await ref.read(addressBookProvider).call(params: {
      'address': ref.read(receipentAddressProvider.notifier).state,
      'label': ref.read(addressLabel.notifier).state,
    });

    if (result.isError) {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          notificationType: NotificationType.error,
          content: result.errorMessage,
        ),
      );

      return false;
    } else {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          notificationType: NotificationType.success,
          content: (result as LoadedState).data['message'] ??
              'Address saved to your address book',
        ),
      );

      return true;
    }
  }

  Future<bool> processSolanaPay() async {
    final result = await ref.read(solanaPayUsecaseProvider).call(params: null);

    if (result.isError) {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          content: result.errorMessage,
          notificationType: NotificationType.error,
        ),
      );

      return false;
    } else {
      ref.read(transactionId.notifier).state =
          (result as LoadedState<String>).data;

      navkey.currentContext!.mixpanel.track(
        MixpanelEvents.sendViaSolanaPay,
      );

      return true;
    }
  }
}

final transferToggleWidgetKey = GlobalKey();
final recipientWidgetKey = GlobalKey();
