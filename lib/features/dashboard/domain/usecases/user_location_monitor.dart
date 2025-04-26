import 'dart:convert';

import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/ip.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/onboarding/data/models/account.dart';
import 'package:guava/features/onboarding/data/repositories/repo.dart';
import 'package:guava/features/onboarding/domain/repositories/repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final userLocationMonitorUsecaseProvider = FutureProvider<bool>(
  (ref) {
    final data = UserLocationMonitorUsecase(
      infoService: ref.watch(ipInfoServiceProvider),
      storageService: ref.watch(securedStorageServiceProvider),
      solanaService: ref.watch(solanaServiceProvider),
      onboardingRepository: ref.watch(onboardingRepositoryProvider),
    );

    return data.call(params: null);
  },
);

class UserLocationMonitorUsecase extends UseCase<bool, Null> {
  UserLocationMonitorUsecase({
    required this.infoService,
    required this.storageService,
    required this.solanaService,
    required this.onboardingRepository,
  });

  final IpInfoService infoService;
  final SecuredStorageService storageService;
  final SolanaService solanaService;
  final OnboardingRepository onboardingRepository;

  @override
  Future<bool> call({required Null params}) async {
    String? myAccountData;

    myAccountData = await storageService.readFromStorage(
      Strings.myAccount,
    );

    if (myAccountData == null) {
      final wallet = await solanaService.walletAddress();

      final account = await onboardingRepository.accountExistence(wallet);

      if (account.isError) {
        return false;
      }

      myAccountData = jsonEncode((account as LoadedState).data['data']);

      storageService.writeToStorage(
        key: Strings.myAccount,
        value: myAccountData,
      );
    }

    final myAccount = AccountModel.fromJson(jsonDecode(myAccountData));
    final ipInfo = await infoService.getIpAddress();

    final result = (ipInfo.country.toLowerCase() !=
        myAccount.deviceInfo['country'].toString().toLowerCase());

    if (result) {
      myAccount.deviceInfo.addAll(ipInfo.toJson());

      // todo: automatically change the country
      final modifiedMyAccount = myAccount.copyWith(
        deviceInfo: myAccount.deviceInfo,
      );

      storageService.writeToStorage(
        key: Strings.myAccount,
        value: jsonEncode(modifiedMyAccount.toJson()),
      );
    }

    return result;
  }
}
