import 'package:equatable/equatable.dart';

class AccountPayable extends Equatable {
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String bankCode;
  final DateTime expiryDate;
  final String? reference;
  final String? currency;

  const AccountPayable({
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.bankCode,
    required this.expiryDate,
    required this.reference,
    required this.currency,
  });

  @override
  List<Object?> get props => [
        accountName,
        accountNumber,
        bankName,
        bankCode,
        expiryDate,
        reference,
        currency,
      ];
}
