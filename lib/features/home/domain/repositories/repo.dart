import 'package:guava/core/resources/network/state.dart';

abstract class HomeRepository {
  Future<AppState> getBalance(String address);
  Future<AppState> getExchangeRate(String currencyCode);
}
