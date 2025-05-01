import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/transfer/data/models/recent_bank_transfer.dart';
import 'package:guava/features/transfer/data/repositories/repo.dart';
import 'package:guava/features/transfer/domain/entities/recent_bank_transfer.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';

final recentBankTransfersProvider =
    FutureProvider<List<RecentBankTransfer>>((ref) async {
  final result = await RecentBankTransferUsecase(
    repository: ref.watch(transferRepositoryProvider),
    solanaService: ref.watch(solanaServiceProvider),
  ).call(params: null);

  if (result.isError) return <RecentBankTransfer>[];

  return (result as LoadedState<List<RecentBankTransfer>>).data;
});

class RecentBankTransferUsecase extends UseCase<AppState, Null> {
  RecentBankTransferUsecase({
    required this.repository,
    required this.solanaService,
  });

  final TransferRepository repository;
  final SolanaService solanaService;

  @override
  Future<AppState> call({required Null params}) async {
    final wallet = await solanaService.walletAddress();

    final result = await repository.getRecentBankTransfer(wallet);

    if (!result.isError) {
      List<RecentBankTransfer> transfers = [];

      transfers = RecentBankTransferModel.toList(
        (result as LoadedState).data['data'],
      );

      return LoadedState<List<RecentBankTransfer>>(transfers);
    }

    return result;
  }
}
