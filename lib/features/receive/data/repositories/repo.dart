import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/network/wrapper.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/features/receive/data/datasources/remote/remote.dart';
import 'package:guava/features/receive/domain/repositories/repo.dart';

final receiveRepositoryProvider = Provider<ReceiveRepository>((ref) {
  return ReceiveRepositoryImpl(
    remoteDatasource: ref.watch(receiveRemoteDatasourceProvider),
    solanaService: ref.watch(solanaServiceProvider),
    wrapper: ref.watch(networkExceptionWrapperProvider),
  );
});

class ReceiveRepositoryImpl implements ReceiveRepository {
  ReceiveRepositoryImpl({
    required this.remoteDatasource,
    required this.wrapper,
    required this.solanaService,
  });

  final ReceiveRemoteDatasource remoteDatasource;
  final NetworkExceptionWrapper wrapper;
  final SolanaService solanaService;

  @override
  Future<AppState> makeADeposit(Map<String, dynamic> data) async {
    final result = await wrapper.format(() async {
      final wallet = await solanaService.walletAddress();

      return await remoteDatasource.makeADeposit(wallet, data);
    });

    return result;
  }
}
