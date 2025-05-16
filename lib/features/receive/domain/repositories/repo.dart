import 'package:guava/core/resources/network/state.dart';

abstract class ReceiveRepository {
  Future<AppState> makeADeposit(Map<String, dynamic> data);
}
