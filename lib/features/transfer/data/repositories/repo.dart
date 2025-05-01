import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/network/wrapper.dart';
import 'package:guava/features/transfer/data/datasources/remote/remote.dart';
import 'package:guava/features/transfer/domain/repositories/repo.dart';

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  return TransferRepositoryImpl(
    remote: ref.watch(transferRemoteProvider),
    wrapper: ref.watch(networkExceptionWrapperProvider),
  );
});

class TransferRepositoryImpl implements TransferRepository {
  TransferRepositoryImpl({
    required this.remote,
    required this.wrapper,
  });

  final TransferRemote remote;
  final NetworkExceptionWrapper wrapper;

  @override
  Future<AppState> resolveUsername(String username) async {
    final result = await wrapper.format(() async {
      return await remote.checkUsername(username);
    });

    return result;
  }

  @override
  Future<AppState> getBankBeneficiaries(String wallet) async {
    final result = await wrapper.format(() async {
      return await remote.getBankBeneficiaries(wallet);
    });

    return result;
  }

  @override
  Future<AppState> getRecentBankTransfer(String wallet) async {
    final result = await wrapper.format(() async {
      return await remote.getRecentBankTransfer(wallet);
    });

    return result;
  }

  @override
  Future<AppState> initBankTransfer(Map<String, dynamic> data) async {
    final result = await wrapper.format(() async {
      return await remote.submitBankTransfer(data);
    });

    return result;
  }

  @override
  Future<AppState> listCountryBanks(String countryCode) async {
    final result = await wrapper.format(() async {
      return await remote.banks(countryCode);
    });

    return result;
  }

  @override
  Future<AppState> resolveAccountName(
    String countryCode,
    Map<String, dynamic> data,
  ) async {
    final result = await wrapper.format(() async {
      return await remote.resolveAccount(countryCode, data);
    });

    return result;
  }

  @override
  Future<AppState> supportedCountries() async {
    final result = await wrapper.format(() async {
      return await remote.countries();
    });

    return result;
  }

  @override
  Future<AppState> addressBook(String wallet) async {
    final result = await wrapper.format(() async {
      return await remote.walletAddressBook(wallet);
    });

    return result;
  }

  @override
  Future<AppState> initWalletTransfer(
      String wallet, Map<String, dynamic> data) async {
    final result = await wrapper.format(() async {
      return await remote.submitWalletTransfer(wallet, data);
    });

    return result;
  }

  @override
  Future<AppState> recentWalletTransfer(String wallet) async {
    final result = await wrapper.format(() async {
      return await remote.recentWalletTransfer(wallet);
    });

    return result;
  }

  @override
  Future<AppState> saveAddress(String wallet, Map<String, dynamic> data) async {
    final result = await wrapper.format(() async {
      return await remote.saveAddress(wallet, data);
    });

    return result;
  }
}
