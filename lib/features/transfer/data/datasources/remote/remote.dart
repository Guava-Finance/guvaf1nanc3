import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/interceptor.dart';

final transferRemoteProvider = Provider<TransferRemote>((ref) {
  return TransferRemoteImpl(
    interceptor: ref.watch(networkInterceptorProvider),
  );
});

abstract class TransferRemote {
  Future<dynamic> checkUsername(String username);
}

class TransferRemoteImpl extends TransferRemote {
  TransferRemoteImpl({
    required this.interceptor,
  });

  final NetworkInterceptor interceptor;

  @override
  Future checkUsername(String username) async {
    return await interceptor.get('/transfer/username/$username/');
  }
}
