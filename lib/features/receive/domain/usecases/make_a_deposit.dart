import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/receive/data/models/account_payable.dart';
import 'package:guava/features/receive/data/repositories/repo.dart';
import 'package:guava/features/receive/domain/entities/account_payable.dart';
import 'package:guava/features/receive/domain/repositories/repo.dart';

final makeADepositProvider = Provider((ref) {
  return MakeADepositUsecase(
    repository: ref.watch(receiveRepositoryProvider),
  );
});

class MakeADepositUsecase extends UseCase<AppState, double> {
  MakeADepositUsecase({
    required this.repository,
  });

  final ReceiveRepository repository;

  @override
  Future<AppState> call({required double params}) async {
    // todo: add the fee to the anount
    final result = await repository.makeADeposit({
      'amount': params,
    });

    if (!result.isError) {
      return LoadedState<AccountPayable>(
        AccountPayableModel.fromJson((result as LoadedState).data['data']),
      );
    }

    return result;
  }
}
