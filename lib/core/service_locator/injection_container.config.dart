// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:mixpanel_flutter/mixpanel_flutter.dart' as _i184;
import 'package:solana/solana.dart' as _i895;

import '../resources/analytics/mixpanel/mix.dart' as _i528;
import '../resources/network/interceptor.dart' as _i969;
import '../resources/network/wrapper.dart' as _i926;
import '../resources/services/encrypt.dart' as _i75;
import '../resources/services/liveliness.dart' as _i465;
import '../resources/services/pubnub.dart' as _i653;
import '../resources/services/solana.dart' as _i597;
import '../resources/services/storage.dart' as _i644;
import 'register_module.dart' as _i291;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  await gh.factoryAsync<_i184.Mixpanel>(
    () => registerModule.mixPanel,
    preResolve: true,
  );
  gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
  gh.lazySingletonAsync<_i558.FlutterSecureStorage>(
      () => registerModule.storage);
  gh.lazySingleton<_i895.RpcClient>(() => registerModule.rpcClient);
  gh.lazySingleton<_i926.NetworkExceptionWrapper>(
      () => _i926.NetworkExceptionWrapper());
  gh.lazySingleton<_i465.LivelinessService>(() => _i465.LivelinessService());
  gh.lazySingleton<_i653.PubSubService>(
      () => _i653.PubSubService(walletAddress: gh<String>()));
  gh.lazySingleton<_i528.MixPanel>(
      () => _i528.MixPanel(mixpanel: gh<_i184.Mixpanel>()));
  gh.lazySingletonAsync<_i644.SecuredStorageService>(
      () async => _i644.SecuredStorageService(
            secureStorage: await gh.getAsync<_i558.FlutterSecureStorage>(),
            encryptionService: gh<_i75.EncryptionService>(),
          ));
  gh.lazySingleton<_i969.NetworkInterceptor>(
      () => _i969.NetworkInterceptor(dio: gh<_i361.Dio>()));
  gh.lazySingletonAsync<_i597.SolanaService>(() async => _i597.SolanaService(
        rpcClient: gh<_i895.RpcClient>(),
        storageService: await gh.getAsync<_i644.SecuredStorageService>(),
        networkInterceptor: gh<_i969.NetworkInterceptor>(),
      ));
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
