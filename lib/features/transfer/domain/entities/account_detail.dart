import 'package:equatable/equatable.dart';

class AccountDetail extends Equatable {
  final String bankName;
  final String bankCode;
  final String accountNumber;
  final String accountName;

  const AccountDetail({
    required this.bankName,
    required this.bankCode,
    required this.accountNumber,
    required this.accountName,
  });

  @override
  List<Object?> get props => [
        bankName,
        bankCode,
        accountNumber,
        accountName,
      ];
}
