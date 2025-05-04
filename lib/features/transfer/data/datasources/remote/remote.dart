import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/interceptor.dart';

final transferRemoteProvider = Provider<TransferRemote>((ref) {
  return TransferRemoteImpl(
    interceptor: ref.watch(networkInterceptorProvider),
  );
});

abstract class TransferRemote {
  Future<dynamic> checkUsername(String username);
  // Bank Transfer
  Future<dynamic> countries();
  Future<dynamic> banks(String countryCode);
  Future<dynamic> resolveAccount(String countryCode, Map<String, dynamic> data);
  Future<dynamic> getRecentBankTransfer(String wallet);
  Future<dynamic> getBankBeneficiaries(String wallet);
  Future<dynamic> submitBankTransfer(String wallet, Map<String, dynamic> data);
  // Wallet Transfer
  Future<dynamic> recentWalletTransfer(String wallet);
  Future<dynamic> walletAddressBook(String wallet);
  Future<dynamic> submitWalletTransfer(
    String wallet,
    Map<String, dynamic> data,
  );
  Future<dynamic> saveAddress(
    String wallet,
    Map<String, dynamic> data,
  );
  Future<dynamic> purpose();
}

class TransferRemoteImpl extends TransferRemote {
  TransferRemoteImpl({
    required this.interceptor,
  });

  final NetworkInterceptor interceptor;

  @override
  Future checkUsername(String username) async {
    return await interceptor.get('/transfer/username/$username/');
  }

  @override
  Future banks(String countryCode) async {
    return await interceptor.get('/transfer/bank/list/$countryCode/');
  }

  @override
  Future countries() async {
    return await interceptor.get('/transfer/bank/country/');
  }

  @override
  Future getBankBeneficiaries(String wallet) async {
    return await interceptor.get(
      '/transfer/bank/beneficiary/$wallet/',
      header: {
        'X-Wallet-Public-Key': wallet,
      },
    );
  }

  @override
  Future getRecentBankTransfer(String wallet) async {
    return await interceptor.get(
      '/transfer/bank/recent/$wallet/',
      header: {
        'X-Wallet-Public-Key': wallet,
      },
    );
  }

  @override
  Future resolveAccount(String countryCode, Map<String, dynamic> data) async {
    return await interceptor.post(
      '/transfer/bank/lookup/$countryCode/',
      data: data,
    );
  }

  @override
  Future submitBankTransfer(String wallet, Map<String, dynamic> data) async {
    return await interceptor.post(
      '/transfer/bank/',
      data: data,
      header: {
        'X-Wallet-Public-Key': wallet,
      },
    );
  }

  @override
  Future recentWalletTransfer(String wallet) async {
    return await interceptor.get(
      '/transfer/wallet/recent/$wallet/',
    );
  }

  @override
  Future submitWalletTransfer(String wallet, Map<String, dynamic> data) async {
    return await interceptor.post(
      '/transfer/wallet/',
      data: data,
      header: {
        'X-Wallet-Public-Key': wallet,
      },
    );
  }

  @override
  Future walletAddressBook(String wallet) async {
    return await interceptor.get(
      '/transfer/wallet/addressbook/$wallet/',
    );
  }

  @override
  Future saveAddress(String wallet, Map<String, dynamic> data) async {
    return await interceptor.post(
      '/transfer/wallet/addressbook/$wallet/',
      data: data,
      header: {
        'X-Wallet-Public-Key': wallet,
      },
    );
  }

  @override
  Future purpose() async {
    return await interceptor.get(
      '/transfer/purpose/',
    );
  }
}
