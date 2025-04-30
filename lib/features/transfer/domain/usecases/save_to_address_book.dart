import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/transfer/data/repositories/repo.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';

final addressBookProvider = Provider<AddressBookUsecase>((ref) {
  return AddressBookUsecase(
    repository: ref.watch(transferRepositoryProvider),
    solanaService: ref.watch(solanaServiceProvider),
  );
});

class AddressBookUsecase extends UseCase<AppState, Map<String, dynamic>> {
  AddressBookUsecase({
    required this.repository,
    required this.solanaService,
  });

  final TransferRepository repository;
  final SolanaService solanaService;

  @override
  Future<AppState> call({required Map<String, dynamic> params}) async {
    final wallet = await solanaService.walletAddress();

    final result = await repository.saveAddress(wallet, params);

    return result;
  }
}
