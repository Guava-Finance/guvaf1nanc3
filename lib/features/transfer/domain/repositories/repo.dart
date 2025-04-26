import 'package:guava/core/resources/network/state.dart';

abstract class TransferRepository {
  Future<AppState> resolveUsername(String username);
}
