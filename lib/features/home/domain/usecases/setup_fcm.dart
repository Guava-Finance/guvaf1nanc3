import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/notification/fcm/fcm.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/home/data/repositories/repo.dart';
import 'package:guava/features/home/domain/repositories/repo.dart';

final setupFcmTokenUsecasesProvider = Provider((ref) {
  return SetupFCMTOkenUsecase(
    repository: ref.watch(homeRepositoryProvider),
    fcmService: ref.watch(fcmProvider),
  );
});

class SetupFCMTOkenUsecase extends UseCase<AppState, Null> {
  SetupFCMTOkenUsecase({
    required this.repository,
    required this.fcmService,
  });

  final HomeRepository repository;
  final FCMService fcmService;

  @override
  Future<AppState> call({required Null params}) async {
    final token = await fcmService.fcmToken();

    if (token != null) {
      final result = await repository.setupFCM(token);

      return result;
    }

    return LoadedState<String>('Token is still valid');
  }
}
