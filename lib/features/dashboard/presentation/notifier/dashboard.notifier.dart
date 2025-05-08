import 'dart:async';

import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/dashboard/domain/usecases/user_location_monitor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard.notifier.g.dart';

@riverpod
class DashboardNotifier extends _$DashboardNotifier {
  @override
  DashboardNotifier build() {
    return this;
  }

  Future<void> checkNCreateUSDCAccount() async {
    final config = await (ref.read(configServiceProvider)).getConfig();

    // final walletAddress = await ref.read(walletAddressProvider.future);
    final solanaService = ref.read(solanaServiceProvider);

    final tokenAccount = await solanaService.doesSPLTokenAccountExist(
      config!.walletSettings.usdcMintAddress,
    );

    // todo: check balance before calling prefund
    // // does prefunding behind the sceen
    // await ref.read(onboardingRepositoryProvider).prefundWallet(walletAddress);

    if (!tokenAccount) {
      await solanaService.enableUSDCForWallet();
    }
  }

  Future<void> hasLocationChanged() async {
    final result = await ref.read(locationMonitorProvider.future);

    if (result) {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          content: 'We noticed your location changed...',
        ),
      );
    }
  }

  // Future<void> initBalanceCheck() async {
  //   final showBalance =
  //       await ref.read(securedStorageServiceProvider).readFromStorage(
  //             Strings.showBalance,
  //           );

  //   AppLogger.log(showBalance);

  //   ref.read(isBalanceVisibleProvider.notifier).state =
  //       !((showBalance != null) && (showBalance == 'true'));
  // }

  // Future<void> toggleShowBalance(bool showBalance) async {
  //   await ref.read(securedStorageServiceProvider).writeToStorage(
  //         key: Strings.showBalance,
  //         value: '$showBalance',
  //       );
  // }
}
