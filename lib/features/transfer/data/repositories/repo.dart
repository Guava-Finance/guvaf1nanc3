import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/network/wrapper.dart';
import 'package:guava/features/transfer/data/datasources/remote/remote.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  return TransferRepositoryImpl(
    remote: ref.watch(transferRemoteProvider),
    wrapper: ref.watch(networkExceptionWrapperProvider),
  );
});

class TransferRepositoryImpl implements TransferRepository {
  TransferRepositoryImpl({
    required this.remote,
    required this.wrapper,
  });

  final TransferRemote remote;
  final NetworkExceptionWrapper wrapper;

  @override
  Future<AppState> resolveUsername(String username) async {
    final result = await wrapper.format(() async {
      return await remote.checkUsername(username);
    });

    return result;
  }
}
