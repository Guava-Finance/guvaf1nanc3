import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/transfer/data/models/country.dart';
import 'package:guava/features/transfer/data/repositories/repo.dart';
import 'package:guava/features/transfer/domain/entities/ccountry.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';

final selectedCountry = StateProvider<Country?>((ref) => null);

final listOfSupportedCountriesProvider =
    FutureProvider<List<Country>?>((ref) async {
  final result = await GetCountriesUsecase(
    repository: ref.watch(transferRepositoryProvider),
  ).call(params: null);

  if (result.isError) return null;

  return (result as LoadedState<List<Country>>).data;
});

class GetCountriesUsecase extends UseCase<AppState, Null> {
  GetCountriesUsecase({
    required this.repository,
  });

  final TransferRepository repository;

  @override
  Future<AppState> call({required Null params}) async {
    final result = await repository.supportedCountries();

    if (result.isError) return result;

    List<Country> countries = [];

    countries = SupportedCountryModel.toList(
      (result as LoadedState).data['data'],
    );

    return LoadedState<List<Country>>(countries);
  }
}
