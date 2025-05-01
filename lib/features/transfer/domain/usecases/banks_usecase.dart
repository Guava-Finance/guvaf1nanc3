import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/transfer/data/models/bank.dart';
import 'package:guava/features/transfer/data/repositories/repo.dart';
import 'package:guava/features/transfer/domain/entities/bank.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';
import 'package:guava/features/transfer/domain/usecases/countries_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final listOfBanksProvider = FutureProvider<List<Bank>?>((ref) async {
  final country = ref.watch(selectedCountry.notifier).state;

  final result = await CountryBanksUsecase(
    repository: ref.watch(transferRepositoryProvider),
  ).call(params: (country?.code ?? '').toUpperCase());

  if (result.isError) return null;

  return (result as LoadedState<List<Bank>>).data;
});

class CountryBanksUsecase extends UseCase<AppState, String> {
  CountryBanksUsecase({
    required this.repository,
  });

  final TransferRepository repository;

  @override
  Future<AppState> call({required String params}) async {
    final result = await repository.listCountryBanks(params);

    if (!result.isError) {
      List<Bank> banks = [];

      banks = BankModel.toList((result as LoadedState).data['data']);

      return LoadedState<List<Bank>>(banks);
    }

    return result;
  }
}
