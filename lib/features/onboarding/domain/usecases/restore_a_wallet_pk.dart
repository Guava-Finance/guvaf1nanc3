import 'dart:convert';

import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/onboarding/data/models/account.dart';
import 'package:guava/features/onboarding/data/repositories/repo.dart';
import 'package:guava/features/onboarding/domain/repositories/repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final restoreAWalletPKUsecaseProvider =
    Provider<RestoreAWalletPKUsecase>((ref) {
  return RestoreAWalletPKUsecase(
    repository: ref.watch(onboardingRepositoryProvider),
    solanaService: ref.watch(solanaServiceProvider),
    storageService: ref.watch(securedStorageServiceProvider),
    configService: ref.watch(configServiceProvider),
  );
});

class RestoreAWalletPKUsecase extends UseCase<AppState, String> {
  RestoreAWalletPKUsecase({
    required this.repository,
    required this.solanaService,
    required this.storageService,
    required this.configService,
  });

  final OnboardingRepository repository;
  final SolanaService solanaService;
  final SecuredStorageService storageService;
  final ConfigService configService;

  @override
  Future<AppState> call({required String params}) async {
    try {
      final config = await configService.getConfig();

      if (config == null) {
        await configService.fetchConfig();
      }

      final wallet = await solanaService.restoreAWalletPK(params);

      AppState? account;

      account = await repository.accountExistence(wallet);

      if (!account.isError) {
        // true means the account does not exist
        if ((account as LoadedState).data['error'] == 'true') {
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
      AppLogger.log(e);
      return ErrorState('Error restoring wallet: $e');
    }
  }
}
