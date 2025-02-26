import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guavafinance/core/resources/env/env.dart';
import 'package:injectable/injectable.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:solana/solana.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );

  @preResolve
  Future<Mixpanel> get mixPanel => Mixpanel.init(
        Env.mixpanel,
        trackAutomaticEvents: true,
      );

  @lazySingleton
  Future<FlutterSecureStorage> get storage async {
    return const FlutterSecureStorage();
  }

  @lazySingleton
  RpcClient get rpcClient => RpcClient(Env.rpcClient);
}
