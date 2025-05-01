import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/rate_rule.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/resources/services/ip.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/onboarding/data/models/account.dart';
import 'package:guava/features/onboarding/domain/entities/config/country.entity.dart';
import 'package:guava/features/transfer/data/models/params/bank_transfer.dart';
import 'package:guava/features/transfer/data/repositories/repo.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';

final bankTransferUsecaseProvider = Provider<BankTransferUsecase>((ref) {
  return BankTransferUsecase(
    repository: ref.watch(transferRepositoryProvider),
    configService: ref.watch(configServiceProvider),
    info: ref.watch(ipInfoServiceProvider),
    storageService: ref.watch(securedStorageServiceProvider),
    solanaService: ref.watch(solanaServiceProvider),
  );
});

class BankTransferUsecase extends UseCase<AppState, BankTransferParam> {
  BankTransferUsecase({
    required this.repository,
    required this.configService,
    required this.info,
    required this.storageService,
    required this.solanaService,
  });

  final TransferRepository repository;
  final ConfigService configService;
  final IpInfoService info;
  final SecuredStorageService storageService;
  final SolanaService solanaService;

  @override
  Future<AppState> call({required BankTransferParam params}) async {
    final config = await configService.getConfig();
    final myAccountData =
        await storageService.readFromStorage(Strings.myAccount);

    if (myAccountData == null) {
      return ErrorState('Your account detail is missing');
    }

    final myAccount = AccountModel.fromJson(jsonDecode(myAccountData));
    final countryCode =
        myAccount.deviceInfo['country'].toString().toLowerCase();

    if (config == null) {
      return ErrorState('App config is missing');
    }

    final exchnageRate =
        await storageService.readFromStorage(Strings.exchangeRate);

    if (exchnageRate == null) {
      return ErrorState('Exchange rate not found');
    }

    CountryEntity? country;

    if (config.countries
        .any((e) => e.countryCode.toLowerCase() == countryCode)) {
      country = config.countries.firstWhere(
        (e) => e.countryCode.toLowerCase() == countryCode,
      );
    } else {
      country = config.countries.first;
    }

    try {
      // in local currency
      final amount = num.parse(params.amount ?? '0').toDouble();

      // convert local currency to usdc amount
      double usdcAmount =
          amount * (num.tryParse(exchnageRate)?.toDouble() ?? 0.0);
      double transactionFee =
          country.rates.offRamp.calculateTransactionFee(usdcAmount);

      final signedTx = await solanaService.transferUSDC(
        amount: usdcAmount,
        receiverAddress: config.companySettings.companyWalletAddress,
        transactionFee: transactionFee,
        narration: params.purpose,
      );

      final newParam = params.copyWith(
        amount: amount.toString(),
        transactionFee: transactionFee.toString(),
        signedTransaction: signedTx,
        type: 'bank',
      );

      AppLogger.log(newParam);

      return await repository.initBankTransfer(newParam.toJson());
    } catch (e) {
      return ErrorState(e.toString());
    }
  }
}
