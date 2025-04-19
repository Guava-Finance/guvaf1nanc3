import 'package:guava/core/resources/network/state.dart';

abstract class OnboardingRepository {
  Future<AppState> prefundWallet(String walletAddress);
  Future<AppState> createWallet(String walletAddress);
  Future<AppState> accountExistence(String walletAddress);
}
