import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/rate_rule.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/onboarding/data/models/account.dart';
import 'package:guava/features/onboarding/domain/entities/config/config.entity.dart';
import 'package:guava/features/onboarding/domain/entities/config/country.entity.dart';
import 'package:guava/features/transfer/data/models/params/solana_pay.dart';

/// Provider for storing the current Solana Pay URL parameters
final solanaPayParam = StateProvider<SolanaPayUrl?>((ref) => null);

// ignore: lines_longer_than_80_chars
/// Provider for calculating the final Solana Pay information including transaction fees
/// based on user's country and configuration
final solanaPayInfo = FutureProvider<SolanaPayUrl>((ref) async {
  try {
    // Get config and account data in parallel
    final configFuture = ref.watch(configServiceProvider).getConfig();
    final myAccountDataFuture = ref
        .watch(securedStorageServiceProvider)
        .readFromStorage(Strings.myAccount);

    final [config, myAccountData] = await Future.wait([
      configFuture,
      myAccountDataFuture,
    ]);

    // Validate essential data
    if (config == null) {
      throw Exception('App configuration is missing');
    }

    if (myAccountData == null) {
      throw Exception('Your account details are missing');
    }

    // Parse account data
    final AccountModel myAccount;

    try {
      myAccount = AccountModel.fromJson(jsonDecode(myAccountData as String));
    } catch (e) {
      throw Exception('Failed to parse account data: ${e.toString()}');
    }

    // Get country code from account data
    final countryCode =
        myAccount.deviceInfo['country']?.toString().toLowerCase();
    if (countryCode == null || countryCode.isEmpty) {
      throw Exception('Country information is missing from account');
    }

    // Get SolanaPayUrl params from state
    final params = ref.watch(solanaPayParam);
    if (params == null) {
      throw Exception('Solana Pay parameters not found');
    }

    // Find country-specific fee information
    CountryEntity? country;

    if ((config as AppConfig)
        .countries
        .any((e) => e.countryCode.toLowerCase() == countryCode)) {
      country = config.countries.firstWhere(
        (e) => e.countryCode.toLowerCase() == countryCode,
      );
    } else {
      country = config.countries.first;
    }

    // Calculate fee based on amount
    final amount = double.tryParse(params.amount ?? '0.0') ?? 0.0;
    double fee = country.rates.offRamp.calculateTransactionFee(amount);

    // Return updated params with fee
    return params.copyWith(
      fee: fee.toStringAsFixed(9),
    ); // Ensure precision for Solana lamports
  } catch (e) {
    // Log error before throwing
    AppLogger.log('Error preparing Solana Pay transaction: ${e.toString()}');
    rethrow;
  }
});

final solanaPayUsecaseProvider = Provider<SolanaPayUsecase>((ref) {
  return SolanaPayUsecase(
    ref: ref,
    solanaService: ref.watch(solanaServiceProvider),
  );
});

/// UseCase for executing Solana Pay transactions
class SolanaPayUsecase extends UseCase<AppState, Null> {
  SolanaPayUsecase({
    required this.solanaService,
    required this.ref,
  });

  final SolanaService solanaService;
  final Ref ref;

  @override
  Future<AppState> call({required Null params}) async {
    try {
      // // Set params first so solanaPayInfo can use them
      // ref.read(solanaPayParam.notifier).state = params;

      // Wait for the enriched payment data with fees
      final newPayment = await ref.watch(solanaPayInfo.future);

      // Execute the payment
      final result = await solanaService.solanaPay(newPayment);

      // Return success state
      return LoadedState<String>(result);
    } catch (e) {
      AppLogger.log('Solana Pay transaction failed: ${e.toString()}');
      return ErrorState(e.toString());
    }
  }
}
