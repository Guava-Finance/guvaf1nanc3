import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/interceptor.dart';

final homeRemoteDatasourceProvider = Provider<HomeRemoteDatasource>((ref) {
  return HomeRemoteDatasourceImpl(
    networkInterceptor: ref.watch(networkInterceptorProvider),
  );
});

abstract class HomeRemoteDatasource {
  Future<dynamic> getBalance(String address);
  Future<dynamic> getExchangeRate(String currencyCode);
  Future<dynamic> checkUsername(String username);
  Future<dynamic> setUsername(String wallet, String username);
  Future<dynamic> history(String wallet);
}

class HomeRemoteDatasourceImpl extends HomeRemoteDatasource {
  HomeRemoteDatasourceImpl({
    required this.networkInterceptor,
  });

  final NetworkInterceptor networkInterceptor;

  @override
  Future getBalance(String address) async {
    return await networkInterceptor.get(
      '/account/balance/$address/',
    );
  }

  @override
  Future getExchangeRate(String currencyCode) async {
    return await networkInterceptor.get(
      '/account/rate/${currencyCode.toUpperCase()}/',
    );
  }

  @override
  Future checkUsername(String username) async {
    return await networkInterceptor.get(
      '/account/username/$username/',
    );
  }

  @override
  Future setUsername(String wallet, String username) async {
    return await networkInterceptor.post(
      '/account/username/',
      data: {'username': username},
      header: {'X-Wallet-Public-Key': wallet},
    );
  }

  @override
  Future history(String wallet) async {
    return await networkInterceptor.get(
      '/transfer/history/$wallet/',
      header: {'X-Wallet-Public-Key': wallet},
    );
  }
}
