import 'package:guava/core/resources/network/interceptor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final receiveRemoteDatasourceProvider = Provider<ReceiveRemoteDatasource>(
  (ref) {
    return ReceiveDatasourceImpl(
      interceptor: ref.watch(networkInterceptorProvider),
    );
  },
);

abstract class ReceiveRemoteDatasource {
  Future<dynamic> makeADeposit(String wallet, Map<String, dynamic> data);
}

class ReceiveDatasourceImpl extends ReceiveRemoteDatasource {
  ReceiveDatasourceImpl({
    required this.interceptor,
  });

  final NetworkInterceptor interceptor;

  @override
  Future makeADeposit(String wallet, Map<String, dynamic> data) async {
    return await interceptor.post(
      '/transfer/bank/receive/',
      data: data,
      header: {
        'X-Wallet-Public-Key': wallet,
      },
    );
  }
}
