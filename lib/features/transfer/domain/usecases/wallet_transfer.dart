import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/rate_rule.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/resources/services/ip.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/onboarding/data/models/account.dart';
import 'package:guava/features/onboarding/domain/entities/config/country.entity.dart';
import 'package:guava/features/transfer/data/models/params/wallet_transfer.dart';
import 'package:guava/features/transfer/data/repositories/repo.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';

final wallTransferUsecaseProvider = Provider<WallTransferUsecase>((ref) {
  return WallTransferUsecase(
    repository: ref.watch(transferRepositoryProvider),
    configService: ref.watch(configServiceProvider),
    info: ref.watch(ipInfoServiceProvider),
    storageService: ref.watch(securedStorageServiceProvider),
    solanaService: ref.watch(solanaServiceProvider),
    ref: ref,
  );
});

final calcTransactionFee = FutureProvider<double>((ref) async {
  final usdcAmount = ref.watch(usdcAountTransfer);

  final config = await ref.watch(configServiceProvider).getConfig();
  final storage = ref.watch(securedStorageServiceProvider);

  final myAccountData = await storage.readFromStorage(Strings.myAccount);

  if (myAccountData == null) {
    throw Exception('Your account detail is missing');
  }

  final myAccount = AccountModel.fromJson(jsonDecode(myAccountData));
  final countryCode = myAccount.deviceInfo['country'].toString().toLowerCase();

  if (config == null) {
    throw Exception('App config is missing');
  }

  CountryEntity? country;

  if (config.countries.any((e) => e.countryCode.toLowerCase() == countryCode)) {
    country = config.countries.firstWhere(
      (e) => e.countryCode.toLowerCase() == countryCode,
    );
  } else {
    country = config.countries.first;
  }

  return country.rates.offRamp.calculateTransactionFee(usdcAmount);
});

class WallTransferUsecase extends UseCase<AppState, WalletTransferParam> {
  WallTransferUsecase({
    required this.repository,
    required this.configService,
    required this.info,
    required this.storageService,
    required this.solanaService,
    required this.ref,
  });

  final TransferRepository repository;
  final ConfigService configService;
  final IpInfoService info;
  final SecuredStorageService storageService;
  final SolanaService solanaService;
  final Ref ref;

  @override
  Future<AppState> call({required WalletTransferParam params}) async {
    final wallet = await solanaService.walletAddress();
    final config = await configService.getConfig();

    try {
      if (config == null) {
        throw Exception('App config is missing');
      }
      // in local currency
      // final amount = num.parse(params.amount ?? '0').toDouble();
      final usdcAmount = ref.watch(usdcAountTransfer.notifier).state;
      final txFee = await ref.watch(calcTransactionFee.future);

      if (params.recipientAddress == null) {
        throw Exception('Recipient address not found');
      }

      await solanaService.checkAndEnableATAForWallet(params.recipientAddress!);

      final signedTx = await solanaService.transferUSDC(
        amount: usdcAmount,
        receiverAddress: params.recipientAddress!,
        transactionFee: txFee,
      );

      AppLogger.log('Signed Tx: $signedTx');

      final signature = await solanaService.walletSignature();

      AppLogger.log('Signature $signature');

      // final newParam = params.copyWith(
      //   amount: usdcAmount.toString(),
      //   transactionFee: txFee.toString(),
      //   signedTransaction: signedTx,
      //   type: 'wallet',
      //   recipientAddress: params.recipientAddress,
      //   senderAddress: wallet,
      // );

      // final result = await repository.initWalletTransfer(
      //   wallet,
      //   newParam.toJson(),
      // );

      // if (!result.isError) {
      //   return LoadedState<Map<String, dynamic>>(
      //     (result as LoadedState).data['data'],
      //   );
      // }

      // return result;
      return ErrorState('');
    } catch (e) {
      return ErrorState(e.toString());
    }
  }
}
