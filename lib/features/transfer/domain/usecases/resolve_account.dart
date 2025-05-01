import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/transfer/data/models/account_detail.dart';
import 'package:guava/features/transfer/data/repositories/repo.dart';
import 'package:guava/features/transfer/domain/entities/account_detail.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';
import 'package:guava/features/transfer/domain/usecases/countries_usecase.dart';

final resolveAccountUsecaseProvider = Provider<ResolveAccountUsecase>((ref) {
  return ResolveAccountUsecase(
    ref: ref,
    repository: ref.watch(transferRepositoryProvider),
  );
});

class ResolveAccountUsecase extends UseCase<AppState, Map<String, dynamic>> {
  ResolveAccountUsecase({
    required this.repository,
    required this.ref,
  });

  final TransferRepository repository;
  final Ref ref;

  @override
  Future<AppState> call({required Map<String, dynamic> params}) async {
    AppLogger.log(params);

    final country = ref.read(selectedCountry.notifier).state;

    final result = await repository.resolveAccountName(
      (country?.code ?? '').toUpperCase(),
      params,
    );

    if (!result.isError) {
      return LoadedState<AccountDetail>(AccountDetailModel.fromJson(
        (result as LoadedState).data['data'],
      ));
    }

    return result;
  }
}
