import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/receive/data/repositories/repo.dart';
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
    final result = await repository.makeADeposit({
      'amount': params,
    });

    return result;
  }
}
