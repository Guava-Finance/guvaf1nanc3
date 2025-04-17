import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/interceptor.dart';
import 'package:guava/features/onboarding/data/models/ip_info.dart';

final onboardingRemoteProvider = Provider<OnboardingRemoteDataSource>((ref) {
  return OnboardingRemoteDataSourceImpl(
    network: ref.watch(networkInterceptorProvider),
  );
});

abstract class OnboardingRemoteDataSource {
  Future<void> prefundWallet(String walletAddress);
  Future<void> createWallet(Map<String, dynamic> data);
  Future<void> walletExistenceCheck(Map<String, dynamic> data);
  Future<IpInfo> getIpAddress();
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final NetworkInterceptor network;

  OnboardingRemoteDataSourceImpl({
    required this.network,
  });

  @override
  Future<void> prefundWallet(String walletAddress) async {
    return await network.post(
      '/auth/prefund/',
      data: {
        'wallet_address': walletAddress,
      },
    );
  }

  @override
  Future<IpInfo> getIpAddress() async {
    final data = await Dio().get('https://ipinfo.io/json');

    return IpInfo.fromJson(data.data);
  }

  @override
  Future<void> createWallet(Map<String, dynamic> data) async {
    return await network.post('/auth/create_wallet/', data: data);
  }

  @override
  Future<void> walletExistenceCheck(Map<String, dynamic> data) async {
    return await network.post('/auth/check/', data: data);
  }
}
