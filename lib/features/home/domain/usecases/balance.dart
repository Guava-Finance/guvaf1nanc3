import 'dart:convert';

import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/home/data/models/balance.param.dart';
import 'package:guava/features/home/data/repositories/repo.dart';
import 'package:guava/features/home/domain/repositories/repo.dart';
import 'package:guava/features/onboarding/data/models/account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final balanceUsecaseProvider = FutureProvider<BalanceParam>((ref) async {
  final balUsecase = BalanceUsecase(
    repository: ref.watch(homeRepositoryProvider),
    solanaService: ref.watch(solanaServiceProvider),
    storageService: ref.watch(securedStorageServiceProvider),
  );

  try {
    return ((await balUsecase.call(params: null)) as LoadedState).data
        as BalanceParam;
  } catch (e) {
    rethrow;
  }
});

class BalanceUsecase extends UseCase<AppState, Null> {
  BalanceUsecase({
    required this.repository,
    required this.solanaService,
    required this.storageService,
  });

  final HomeRepository repository;
  final SolanaService solanaService;
  final SecuredStorageService storageService;

  @override
  Future<AppState> call({required Null params}) async {
    final wallet = await solanaService.walletAddress();

    final balance = await repository.getBalance(wallet);

    if (balance.isError) {
      return ErrorState('Error getting balance');
    }

    final myAccountData = await storageService.readFromStorage(
      Strings.myAccount,
    );

    if (myAccountData == null) {
      return ErrorState('Account data not found');
    }

    final account = AccountModel.fromJson(jsonDecode(myAccountData));
    final countryCode = account.deviceInfo['country'].toString().toLowerCase();

    // todo: get currency code from config using the [countryCode]
    // temp implementation
    final cc = (countryCode == 'ng' ? 'NGN' : 'USD').toUpperCase();
    final currencySymbol = (countryCode == 'ng' ? '₦' : '\$');

    final rate = await repository.getExchangeRate(cc);

    if (rate.isError) {
      return ErrorState('Error getting exchange rate');
    }

    final usdc =
        double.tryParse((balance as LoadedState).data['data']['USDC']) ?? 0.0;
    final excRate =
        double.tryParse((rate as LoadedState).data['data'][cc]) ?? 0.0;

    // save the exgchange rate to storage
    await storageService.writeToStorage(
      key: Strings.exchangeRate,
      value: jsonEncode(rate.data['data']),
    );

    return LoadedState(BalanceParam.fromJson({
      'usdcBalance': usdc,
      'exchangeRate': excRate,
      'localBalance': usdc / excRate,
      'symbol': currencySymbol,
    }));
  }
}
