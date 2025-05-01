import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/interceptor.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/network/wrapper.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/features/onboarding/data/models/config/config.model.dart';
import 'package:guava/features/onboarding/domain/entities/config/config.entity.dart';

final configServiceProvider = Provider<ConfigService>((ref) {
  return ConfigService(
    network: ref.watch(networkInterceptorProvider),
    wrapper: ref.watch(networkExceptionWrapperProvider),
    storageService: ref.watch(securedStorageServiceProvider),
  );
});

final appConfig = StateProvider<AppConfigModel?>((ref) {
  return null;
});

class ConfigService {
  ConfigService({
    required this.network,
    required this.wrapper,
    required this.storageService,
  });

  final NetworkInterceptor network;
  final NetworkExceptionWrapper wrapper;
  final SecuredStorageService storageService;

  Future<void> fetchConfig() async {
    final config = await getConfig();

    if (config != null) {
      unawaited(_remoteConfigFetch());
    } else {
      await _remoteConfigFetch();
    }
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
    }
  }

  Future<AppConfig?> getConfig() async {
    final data = await storageService.readFromStorage(Strings.myConfig);

    if (data == null) return null;

    return AppConfigModel.fromJson(jsonDecode(data));
  }
}
