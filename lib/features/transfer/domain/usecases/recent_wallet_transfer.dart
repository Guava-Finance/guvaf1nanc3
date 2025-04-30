import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/transfer/data/models/recent_wallet_transfer.dart';
import 'package:guava/features/transfer/data/repositories/repo.dart';
import 'package:guava/features/transfer/domain/entities/recent_wallet_transfer.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';

final recentWalletTransfers =
    FutureProvider<List<RecentWalletTransfer>?>((ref) async {
  final result = await RecentWalletTransfersUsecase(
    repository: ref.watch(transferRepositoryProvider),
    solanaService: ref.watch(solanaServiceProvider),
  ).call(params: null);

  if (result.isError) return null;

  return (result as LoadedState<List<RecentWalletTransfer>>).data;
});

class RecentWalletTransfersUsecase extends UseCase<AppState, Null> {
  RecentWalletTransfersUsecase({
    required this.repository,
    required this.solanaService,
  });

  final TransferRepository repository;
  final SolanaService solanaService;

  @override
  Future<AppState> call({required Null params}) async {
    final wallet = await solanaService.walletAddress();

    final result = await repository.recentWalletTransfer(wallet);

    if (!result.isError) {
      List<RecentWalletTransfer> transfers = RecentTransferWalletModel.toList(
        (result as LoadedState).data['data'],
      );

      return LoadedState<List<RecentWalletTransfer>>(transfers);
    }

    return result;
  }
}
