import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/home/data/repositories/repo.dart';
import 'package:guava/features/home/domain/repositories/repo.dart';

final setUsernameUsecaseProvider = Provider<SetUsernameUsecase>((ref) {
  return SetUsernameUsecase(
    repository: ref.watch(homeRepositoryProvider),
    solanaService: ref.watch(solanaServiceProvider),
    storageService: ref.watch(securedStorageServiceProvider),
  );
});

class SetUsernameUsecase extends UseCase<AppState, String> {
  SetUsernameUsecase({
    required this.repository,
    required this.solanaService,
    required this.storageService,
  });

  final HomeRepository repository;
  final SolanaService solanaService;
  final SecuredStorageService storageService;

  @override
  Future<AppState> call({required String params}) async {
    final wallet = await solanaService.walletAddress();

    final result = await repository.setUsername(wallet, params);

    // saved username locally
    // if (!result.isError) unawaited(_cachedUsername(params));
    if (!result.isError) await _cachedUsername(params);

    return result;
  }

  Future<void> _cachedUsername(String username) async {
    await storageService.writeToStorage(
      key: Strings.myUsername,
      value: username,
    );
  }
}
