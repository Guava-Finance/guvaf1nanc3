import 'package:equatable/equatable.dart';

class RecentWalletTransfer extends Equatable {
  final String address;
  final String username;
  final DateTime lastTransferAt;

  const RecentWalletTransfer({
    required this.address,
    required this.username,
    required this.lastTransferAt,
  });

  @override
  List<Object?> get props => [address, username, lastTransferAt];
}
