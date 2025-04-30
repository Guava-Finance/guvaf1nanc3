import 'package:equatable/equatable.dart';

class BankBeneficiary extends Equatable {
  final String accountName;
  final String accountNumber;
  final String bank;
  final String country;
  final DateTime createdAt;

  const BankBeneficiary({
    required this.accountName,
    required this.accountNumber,
    required this.bank,
    required this.country,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        accountName,
        accountNumber,
        bank,
        country,
        createdAt,
      ];
}
