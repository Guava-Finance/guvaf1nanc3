import 'dart:convert';

import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/onboarding/data/models/account.dart';
import 'package:guava/features/onboarding/data/repositories/repo.dart';
import 'package:guava/features/onboarding/domain/repositories/repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final restoreAWalletMnemonicsUsecaseProvider =
    Provider<RestoreAWalletMnemonicsUsecase>((ref) {
  return RestoreAWalletMnemonicsUsecase(
    repository: ref.watch(onboardingRepositoryProvider),
    solanaService: ref.watch(solanaServiceProvider),
    storageService: ref.watch(securedStorageServiceProvider),
  );
});

class RestoreAWalletMnemonicsUsecase extends UseCase<AppState, String> {
  RestoreAWalletMnemonicsUsecase({
    required this.repository,
    required this.solanaService,
    required this.storageService,
  });

  final OnboardingRepository repository;
  final SolanaService solanaService;
  final SecuredStorageService storageService;

  @override
  Future<AppState> call({required String params}) async {
    try {
      if (!solanaService.isMnemonicValid(params)) {
        return ErrorState('Invalid mnemonic');
      }

      final wallet = await solanaService.restoreAWallet(params);

      AppState? account;

      account = await repository.accountExistence(wallet);

      if (!account.isError) {
        // true means the account does not exist
        if ((account as LoadedState).data['error'] == 'true') {
          AppLogger.log(account.data);
          // then create the account on Guava system
          account = await repository.createWallet(wallet);
        }

        final myAccount = AccountModel.fromJson(
          (account as LoadedState).data['data'],
        );

        // save account profile to storage securely
        storageService.writeToStorage(
          key: Strings.myAccount,
          value: jsonEncode(myAccount.toJson()),
        );

        // prefunds the wallet
        await repository.prefundWallet(wallet);

        // // todo: fetch mint from config
        // final tokenAccount = await solanaService.doesSPLTokenAccountExist(
        //   Strings.usdcMintTokenAddress,
        // );

        // if (!tokenAccount) {
        //   await Future.delayed(Duration(seconds: 7));
        //   await solanaService.enableUSDCForWallet();
        // }

        return account;
      }

      return ErrorState('Something went wrong');
    } catch (e) {
      return ErrorState('Error restoring wallet: $e');
    }
  }
}
