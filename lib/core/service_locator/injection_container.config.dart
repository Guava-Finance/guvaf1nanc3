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

import '../../data/datasources/local/wallet.dart' as _i47;
import '../../data/datasources/remote/wallet.dart' as _i299;
import '../resources/analytics/mixpanel/mix.dart' as _i528;
import '../resources/services/pubnub.dart' as _i978;
import '../resources/network/interceptor.dart' as _i969;
import '../resources/network/wrapper.dart' as _i926;
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
  gh.lazySingleton<_i978.PubSubService>(
      () => _i978.PubSubService(walletAddress: gh<String>()));
  gh.lazySingleton<_i528.MixPanel>(
      () => _i528.MixPanel(mixpanel: gh<_i184.Mixpanel>()));
  gh.lazySingleton<_i969.NetworkInterceptor>(
      () => _i969.NetworkInterceptor(dio: gh<_i361.Dio>()));
  gh.lazySingletonAsync<_i47.LocalWalletFunctions>(() async =>
      _i47.LocalWalletFunctionsImpl(
          secureStorage: await gh.getAsync<_i558.FlutterSecureStorage>()));
  gh.lazySingletonAsync<_i299.RemoteWalletFunctions>(
      () async => _i299.RemoteWalletFunctionsImpl(
            rpcClient: gh<_i895.RpcClient>(),
            secureStorage: await gh.getAsync<_i558.FlutterSecureStorage>(),
            networkInterceptor: gh<_i969.NetworkInterceptor>(),
          ));
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
