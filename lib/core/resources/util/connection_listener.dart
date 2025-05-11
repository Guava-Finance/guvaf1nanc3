import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/home/domain/usecases/history.dart';
import 'package:guava/features/transfer/domain/usecases/address_book.dart';
import 'package:guava/features/transfer/domain/usecases/bank_beneficiary.dart';
import 'package:guava/features/transfer/domain/usecases/recent_bank_transfer.dart';
import 'package:guava/features/transfer/domain/usecases/recent_wallet_transfer.dart';

final connectivityStatusProvider =
    StateNotifierProvider<ConnectivityNotifier, bool>((ref) {
  return ConnectivityNotifier(ref);
});

class ConnectivityNotifier extends StateNotifier<bool> {
  final Ref ref;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityNotifier(this.ref) : super(true) {
    _subscription = Connectivity().onConnectivityChanged.listen(
      _handleStatusChange,
      onError: (e) {
        AppLogger.log('Connectivity stream error: $e');
      },
      onDone: () {},
    );

    _initialize();
  }

  Future<void> _initialize() async {
    final result = await Connectivity().checkConnectivity();
    _handleStatusChange(result);
  }

  void _handleStatusChange(List<ConnectivityResult> results) {
    AppLogger.log(results.first.name);

    for (var result in results) {
      final hasConnection = result != ConnectivityResult.none;
      final wasDisconnected = state == false;

      state = hasConnection;

      if (hasConnection && wasDisconnected) {
        AppLogger.log('reconnecting');
        // Homepage
        ref.invalidate(balanceUsecaseProvider);
        ref.invalidate(myTransactionHistory);
        // Transfer/Wallet
        ref.invalidate(recentWalletTransfers);
        ref.invalidate(myAddressBook);
        // Transfer/Bank
        ref.invalidate(recentBankTransfersProvider);
        ref.invalidate(bankBeneficiaryProvider);

        // show a notification
        navkey.currentContext!.notify.addNotification(
          NotificationTile(
            content: 'Internet connection restored',
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
