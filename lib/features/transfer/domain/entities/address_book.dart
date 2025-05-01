import 'package:equatable/equatable.dart';

class WalletAddressBook extends Equatable {
  final String id;
  final String address;
  final String username;
  final String label;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WalletAddressBook({
    required this.id,
    required this.address,
    required this.username,
    required this.label,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        address,
        username,
        label,
        createdAt,
        updatedAt,
      ];
}
