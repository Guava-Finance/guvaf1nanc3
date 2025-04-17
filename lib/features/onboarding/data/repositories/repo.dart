import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/network/wrapper.dart';
import 'package:guava/features/onboarding/data/datasources/local/local.dart';
import 'package:guava/features/onboarding/data/datasources/remote/remote.dart';
import 'package:guava/features/onboarding/domain/repositories/repo.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepositoryImpl(
    remoteDataSource: ref.watch(onboardingRemoteProvider),
    wrapper: ref.watch(networkExceptionWrapperProvider),
    localDatasource: ref.watch(localDatasourceProvider),
  );
});

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl({
    required this.remoteDataSource,
    required this.wrapper,
    required this.localDatasource,
  });

  final OnboardingRemoteDataSource remoteDataSource;
  final NetworkExceptionWrapper wrapper;
  final LocalDatasource localDatasource;

  @override
  Future<AppState> prefundWallet(String walletAddress) async {
    final result = await wrapper.format(() async {
      return await remoteDataSource.prefundWallet(walletAddress);
    });

    return result;
  }

  @override
  Future<AppState> createWallet(String walletAddress) async {
    Map<String, dynamic> data = {};

    final ipInfo = await remoteDataSource.getIpAddress();

    var deviceInfo = await localDatasource.getDeviceInformation();
    deviceInfo.addAll(ipInfo.toJson());

    data['device_info'] = jsonEncode(deviceInfo);
    data['ip_address'] = ipInfo.ip;
    data['wallet_address'] = walletAddress;

    final result = await wrapper.format(() async {
      return await remoteDataSource.createWallet(data);
    });

    return result;
  }

  @override
  Future<AppState> accountExistence(String walletAddress) async {
    final result = await wrapper.format(() async {
      return await remoteDataSource.walletExistenceCheck({
        'address': walletAddress,
      });
    });

    return result;
  }
}
