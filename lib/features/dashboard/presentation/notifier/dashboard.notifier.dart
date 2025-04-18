import 'dart:async';

import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/services/solana.dart';
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
    // final walletAddress = await ref.read(walletAddressProvider.future);
    final solanaService = ref.read(solanaServiceProvider);

    final tokenAccount = await solanaService.doesSPLTokenAccountExist(
      Strings.usdcMintTokenAddress,
    );

    // todo: check balance before calling prefund
    // // does prefunding behind the sceen
    // await ref.read(onboardingRepositoryProvider).prefundWallet(walletAddress);

    if (!tokenAccount) {
      await solanaService.enableUSDCForWallet();
    }
  }

  Future<void> hasLocationChanged() async {
    final result = await ref.read(userLocationMonitorUsecaseProvider.future);
    // todo: if country has changed do something
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
