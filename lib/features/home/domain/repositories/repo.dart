import 'package:guava/core/resources/network/state.dart';

abstract class HomeRepository {
  Future<AppState> getBalance(String address);
  Future<AppState> getExchangeRate(String currencyCode);
  Future<AppState> checkUsername(String username);
  Future<AppState> setUsername(String wallet, String username);
}
