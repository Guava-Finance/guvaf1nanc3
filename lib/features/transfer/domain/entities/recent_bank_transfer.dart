import 'package:equatable/equatable.dart';

class RecentBankTransfer extends Equatable {
  final String accountName;
  final String accountNumber;
  final String bank;
  final String country;
  final double amount;
  final DateTime date;
  final String status;

  const RecentBankTransfer({
    required this.accountName,
    required this.accountNumber,
    required this.bank,
    required this.country,
    required this.amount,
    required this.date,
    required this.status,
  });

  @override
  List<Object?> get props => [
        accountName,
        accountNumber,
        bank,
        country,
        amount,
        date,
        status,
      ];
}
