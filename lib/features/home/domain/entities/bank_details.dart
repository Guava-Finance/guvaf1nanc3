import 'package:equatable/equatable.dart';

class BankDetails extends Equatable {
  final String? accountName;
  final String? accountNumber;
  final String? bank;
  final String? country;
  final String? purpose;
  final String? externalReference;
  final String? externalStatus;

  const BankDetails({
    this.accountName,
    this.accountNumber,
    this.bank,
    this.country,
    this.purpose,
    this.externalReference,
    this.externalStatus,
  });

  @override
  List<Object?> get props => [
        accountName,
        accountNumber,
        bank,
        country,
        purpose,
        externalReference,
        externalStatus,
      ];
}
