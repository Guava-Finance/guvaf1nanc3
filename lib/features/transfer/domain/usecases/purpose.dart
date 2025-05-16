import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/transfer/data/models/purpose.dart';
import 'package:guava/features/transfer/data/repositories/repo.dart';
import 'package:guava/features/transfer/domain/entities/purpose.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';

final lisOfTransferPurpose =
    FutureProvider<List<TransferPurpose>?>((ref) async {
  final result = await ref.watch(purposeUsecaseProvder).call(params: null);

  if (result.isError) return null;

  return (result as LoadedState<List<TransferPurpose>>).data;
});

final purposeUsecaseProvder = Provider<PurposeUsecase>((ref) {
  return PurposeUsecase(
    repository: ref.watch(transferRepositoryProvider),
  );
});

class PurposeUsecase extends UseCase<AppState, Null> {
  PurposeUsecase({
    required this.repository,
  });

  final TransferRepository repository;

  @override
  Future<AppState> call({required Null params}) async {
    final result = await repository.purpose();

    if (result.isError) return result;

    List<TransferPurpose> purposes = [];

    purposes = TransferPurposeModel.toList(
      (result as LoadedState).data['data'],
    );

    return LoadedState<List<TransferPurpose>>(purposes);
  }
}
