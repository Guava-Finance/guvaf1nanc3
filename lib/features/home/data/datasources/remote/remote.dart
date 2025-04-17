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
}
