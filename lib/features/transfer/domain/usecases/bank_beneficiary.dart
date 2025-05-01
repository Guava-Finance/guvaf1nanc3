import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/transfer/data/models/bank_beneficiary.dart';
import 'package:guava/features/transfer/data/repositories/repo.dart';
import 'package:guava/features/transfer/domain/entities/bank_beneficiary.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';

final bankBeneficiaryProvider =
    FutureProvider<List<BankBeneficiary>>((ref) async {
  final result = await BankBeneficiaryUsecase(
    repository: ref.watch(transferRepositoryProvider),
    solanaService: ref.watch(solanaServiceProvider),
  ).call(params: null);

  if (result.isError) return <BankBeneficiary>[];

  return (result as LoadedState<List<BankBeneficiary>>).data;
});

class BankBeneficiaryUsecase extends UseCase<AppState, Null> {
  BankBeneficiaryUsecase({
    required this.repository,
    required this.solanaService,
  });

  final TransferRepository repository;
  final SolanaService solanaService;

  @override
  Future<AppState> call({required Null params}) async {
    final wallet = await solanaService.walletAddress();

    final result = await repository.getBankBeneficiaries(wallet);

    if (!result.isError) {
      List<BankBeneficiary> transfers = [];

      transfers = BankBeneficiaryModel.toList(
        (result as LoadedState).data['data'],
      );

      return LoadedState<List<BankBeneficiary>>(transfers);
    }

    return result;
  }
}
