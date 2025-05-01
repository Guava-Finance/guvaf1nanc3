import 'package:guava/core/resources/network/state.dart';

abstract class TransferRepository {
  Future<AppState> resolveUsername(String username);
  Future<AppState> supportedCountries();
  Future<AppState> listCountryBanks(String countryCode);
  Future<AppState> resolveAccountName(
      String countryCode, Map<String, dynamic> data);
  Future<AppState> getRecentBankTransfer(String wallet);
  Future<AppState> getBankBeneficiaries(String wallet);
  Future<AppState> initBankTransfer(Map<String, dynamic> data);
  Future<AppState> recentWalletTransfer(String wallet);
  Future<AppState> addressBook(String wallet);
  Future<AppState> initWalletTransfer(String wallet, Map<String, dynamic> data);
  Future<AppState> saveAddress(String wallet, Map<String, dynamic> data);
}
