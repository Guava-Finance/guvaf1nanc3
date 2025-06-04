import 'dart:async';
import 'dart:convert';

import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/home/data/models/balance.param.dart';
import 'package:guava/features/home/data/models/token_account.dart';
import 'package:guava/features/home/data/repositories/repo.dart';
import 'package:guava/features/home/domain/repositories/repo.dart';
import 'package:guava/features/onboarding/data/models/account.dart';
import 'package:guava/features/onboarding/domain/entities/config/country.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final balanceUsecaseProvider = FutureProvider<BalanceParam>((ref) async {
  final balUsecase = ref.watch(balanceUsecaseProvidr);

  try {
    final result = await balUsecase.call(params: null);
    return (result as LoadedState).data as BalanceParam;
  } catch (e) {
    navkey.currentContext!.notify.addNotification(
      NotificationTile(
        title: 'Balance Update Failed',
        content:
            '''Could not retrieve your latest balance. Showing your last known balance.''',
        notificationType: NotificationType.error,
      ),
    );

    throw Exception(e.toString());
  }
});

final allAssetBalance = FutureProvider<List<TokenAccount>>((ref) async {
  final solana = ref.watch(solanaServiceProvider);
  final config = await ref.watch(configServiceProvider).getConfig();

  // final solBalance = await solana.getSolBalanceAsTokenAccount();
  final tokens = await solana.allAssets();

  tokens.removeWhere((e) => e.mint == config?.walletSettings.usdcMintAddress);
  tokens.removeWhere((e) => e.amount < 0.1);
  // tokens.removeWhere((e) => e.splToken == null);

  return [...tokens];
});

final cachedBalanceProivder =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  final data = await ref
      .read(securedStorageServiceProvider)
      .readFromStorage(Strings.myCachedBalance);

  if (data != null) return jsonDecode(data);

  return null;
});

final balanceUsecaseProvidr = Provider<BalanceUsecase>((ref) {
  return BalanceUsecase(
    repository: ref.watch(homeRepositoryProvider),
    solanaService: ref.watch(solanaServiceProvider),
    storageService: ref.watch(securedStorageServiceProvider),
    configService: ref.watch(configServiceProvider),
  );
});

class BalanceUsecase extends UseCase<AppState, Null> {
  BalanceUsecase({
    required this.repository,
    required this.solanaService,
    required this.storageService,
    required this.configService,
  });

  final HomeRepository repository;
  final SolanaService solanaService;
  final SecuredStorageService storageService;
  final ConfigService configService;

  @override
  Future<AppState> call({required Null params}) async {
    try {
      final wallet = await solanaService.walletAddress();
      final config = await configService.getConfig();

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
      final countryCode =
          account.deviceInfo['country'].toString().toLowerCase();

      CountryEntity? country;

      if (config?.countries.any(
            (e) => e.countryCode.toLowerCase() == countryCode,
          ) ??
          false) {
        country = config?.countries.firstWhere(
          (e) => e.countryCode.toLowerCase() == countryCode,
        );
      }

      // fetch country code and currency from the config file
      final currencySymbol = country?.currencySymbol ?? '\$';
      final cc = country?.currencyCode.toUpperCase() ?? 'USD';

      final rate = await repository.getExchangeRate(cc);

      if (rate.isError) {
        return ErrorState('Error getting exchange rate');
      }

      final usdc =
          double.tryParse((balance as LoadedState).data['data']['USDC']) ?? 0.0;
      final excRate =
          double.tryParse((rate as LoadedState).data['data'][cc]) ?? 0.0;

      // save local balance & usdc balance incase there's an error fetching
      // operation runs on background
      // Run storage operations in the background using Future.wait
      // This won't block the UI since we're not awaiting the result
      unawaited(_performBackgroundStorageOperations(
        usdc: usdc,
        excRate: excRate,
        currencySymbol: currencySymbol,
      ));

      return LoadedState(BalanceParam.fromJson({
        'usdcBalance': usdc,
        'exchangeRate': excRate,
        'localBalance': (usdc * excRate),
        'symbol': currencySymbol,
      }));
    } catch (e) {
      return ErrorState(e.toString());
    }
  }

  // Helper method to perform background storage operations
  Future<void> _performBackgroundStorageOperations({
    required double usdc,
    required double excRate,
    required String currencySymbol,
  }) async {
    // Save the exchange rate to storage to be used on other sessions
    await storageService.writeToStorage(
      key: Strings.exchangeRate,
      value: excRate.toString(),
    );

    // Save local balance & usdc balance in case there's an error fetching
    await storageService.writeToStorage(
      key: Strings.myCachedBalance,
      value: jsonEncode({
        'localBalance': (usdc * excRate),
        'usdcBalance': usdc,
        'symbol': currencySymbol,
        'exchangeRate': currencySymbol,
      }),
    );
  }
}
