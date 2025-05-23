import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/env/env.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/interceptor.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/network/wrapper.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/features/home/data/models/spl_token.dart';
import 'package:guava/features/onboarding/data/models/account.dart';
import 'package:guava/features/onboarding/data/models/config/config.model.dart';
import 'package:guava/features/onboarding/domain/entities/config/config.entity.dart';
import 'package:guava/features/onboarding/domain/entities/config/country.entity.dart';

final configServiceProvider = Provider<ConfigService>((ref) {
  return ConfigService(
    network: ref.watch(networkInterceptorProvider),
    wrapper: ref.watch(networkExceptionWrapperProvider),
    storageService: ref.watch(securedStorageServiceProvider),
    ref: ref,
  );
});

final userCountry = StateProvider<CountryEntity?>((ref) {
  return null;
});

final splTokenAccounts = StateProvider<Map<String, SplToken>>((ref) => {});

class ConfigService {
  ConfigService({
    required this.network,
    required this.wrapper,
    required this.storageService,
    required this.ref,
  });

  final NetworkInterceptor network;
  final NetworkExceptionWrapper wrapper;
  final SecuredStorageService storageService;
  final Ref ref;

  Future<void> fetchConfig() async {
    final config = await getConfig();

    if (config != null) {
      unawaited(_remoteConfigFetch());
    } else {
      await _remoteConfigFetch();
    }

    unawaited(splTokenFetch());
  }

  Future<void> _remoteConfigFetch() async {
    final result = await wrapper.format(() async {
      return await network.get('/system/config/');
    });

    if (!result.isError) {
      // fetch the config and cache it
      final data = (result as LoadedState).data['data'];

      await storageService.writeToStorage(
        key: Strings.myConfig,
        value: jsonEncode(data),
      );

      ref.watch(userCountry.notifier).state = (await _cherryPickCountry(
        AppConfigModel.fromJson(data!),
      ));
    }
  }

  Future<AppConfig?> getConfig() async {
    final data = await storageService.readFromStorage(Strings.myConfig);

    if (data == null) return null;

    final config = AppConfigModel.fromJson(jsonDecode(data));

    ref.watch(userCountry.notifier).state = (await _cherryPickCountry(config));

    return config;
  }

  Future<CountryEntity> _cherryPickCountry(AppConfig config) async {
    final storage = ref.read(securedStorageServiceProvider);
    final accountData = await storage.readFromStorage(Strings.myAccount);

    if (accountData != null) {
      final account = AccountModel.fromJson(jsonDecode(accountData));

      if (config.countries.any((e) =>
          e.countryCode.toLowerCase() ==
          account.deviceInfo['country'].toString().toLowerCase())) {
        return config.countries.firstWhere((e) =>
            e.countryCode.toLowerCase() ==
            account.deviceInfo['country'].toString().toLowerCase());
      } else {
        return config.countries.first;
      }
    }

    return config.countries.first;
  }

  Future<void> _getNetworkSplTokens() async {
    try {
      final res = await Dio().get(Env.splTokenUrl);
      if (res.statusCode == 200) {
        final data = res.data;
        await storageService.writeToStorage(
          key: Strings.splTokenList,
          value: data,
        );
        final tokens = SplToken.toList(jsonDecode(data)['tokens']);
        final tokenMap = {for (var t in tokens) t.address: t};
        ref.read(splTokenAccounts.notifier).state = tokenMap;
        return;
      }
    } catch (_) {}

    final fallback = await storageService.readFromStorage(Strings.splTokenList);
    if (fallback != null) {
      final tokens = SplToken.toList(jsonDecode(fallback)['tokens']);
      final tokenMap = {for (var t in tokens) t.address: t};
      ref.read(splTokenAccounts.notifier).state = tokenMap;
    }
  }

  Future<void> splTokenFetch() async {
    final cachedData =
        await storageService.readFromStorage(Strings.splTokenList);

    if (cachedData != null) {
      final tokens = SplToken.toList(jsonDecode(cachedData)['tokens']);
      final tokenMap = {for (var t in tokens) t.address: t};
      ref.read(splTokenAccounts.notifier).state = tokenMap;
      unawaited(_getNetworkSplTokens());
    } else {
      await _getNetworkSplTokens();
    }
  }
}
