import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/usecase/usecase.dart';
import 'package:guava/features/transfer/data/models/address_book.dart';
import 'package:guava/features/transfer/data/repositories/repo.dart';
import 'package:guava/features/transfer/domain/entities/address_book.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';

final myAddressBook = FutureProvider<List<WalletAddressBook>?>((ref) async {
  final result = await AddressBookUsecase(
    repository: ref.watch(transferRepositoryProvider),
    solanaService: ref.watch(solanaServiceProvider),
  ).call(params: null);

  if (result.isError) return null;

  return (result as LoadedState<List<WalletAddressBook>>).data;
});

class AddressBookUsecase extends UseCase<AppState, Null> {
  AddressBookUsecase({
    required this.repository,
    required this.solanaService,
  });

  final TransferRepository repository;
  final SolanaService solanaService;

  @override
  Future<AppState> call({required Null params}) async {
    final wallet = await solanaService.walletAddress();

    final result = await repository.addressBook(wallet);

    if (!result.isError) {
      List<WalletAddressBook> addresses = WalletAddressBookModel.toList(
        (result as LoadedState).data['data'],
      );

      return LoadedState<List<WalletAddressBook>>(addresses);
    }

    return result;
  }
}
