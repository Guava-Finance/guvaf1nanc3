import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/home/data/repositories/repo.dart';
import 'package:guava/features/home/domain/repositories/repo.dart';

final checkUsernameUsecaseProvider = Provider<CheckUsernameUsecase>((ref) {
  return CheckUsernameUsecase(
    repository: ref.watch(homeRepositoryProvider),
  );
});

class CheckUsernameUsecase extends UseCase<AppState, String> {
  CheckUsernameUsecase({
    required this.repository,
  });

  final HomeRepository repository;

  @override
  Future<AppState> call({required String params}) async {
    return await repository.checkUsername(params);
  }
}
