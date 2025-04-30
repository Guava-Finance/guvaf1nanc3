import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/home/data/models/transaction_history.dart';
import 'package:guava/features/home/data/repositories/repo.dart';
import 'package:guava/features/home/domain/entities/transaction_history.dart';
import 'package:guava/features/home/domain/repositories/repo.dart';

final allTransactionHistory = StateProvider<List<TransactionsHistory>>((ref) {
  return [];
});

final tempTransactionHistory = StateProvider<List<TransactionsHistory>>((ref) {
  return [];
});

final myTransactionHistory =
    FutureProvider<List<TransactionsHistory>?>((ref) async {
  final result =
      await ref.watch(transactionHistoryUsecaseProvider).call(params: null);

  if (result.isError) return null;

  final data = (result as LoadedState<List<TransactionsHistory>>).data;

  ref.watch(allTransactionHistory.notifier).state = [...data];
  ref.watch(tempTransactionHistory.notifier).state = [...data];

  return data;
});

final transactionHistoryUsecaseProvider =
    Provider<TransactionHistoryUsecase>((ref) {
  return TransactionHistoryUsecase(
    repository: ref.watch(homeRepositoryProvider),
    solanaService: ref.watch(solanaServiceProvider),
  );
});

class TransactionHistoryUsecase extends UseCase<AppState, Null> {
  TransactionHistoryUsecase({
    required this.repository,
    required this.solanaService,
  });

  final HomeRepository repository;
  final SolanaService solanaService;

  @override
  Future<AppState> call({required Null params}) async {
    final wallet = await solanaService.walletAddress();

    final result = await repository.histroy(wallet);

    if (!result.isError) {
      List<TransactionsHistory> histories = TransactionHistoryModel.toList(
        (result as LoadedState).data['data'],
      );

      return LoadedState<List<TransactionsHistory>>(histories);
    }

    return result;
  }
}
