import 'package:guava/features/home/domain/entities/bank_details.dart';

class BankDetaislModel extends BankDetails {
  const BankDetaislModel({
    super.accountName,
    super.accountNumber,
    super.bank,
    super.country,
    super.externalReference,
    super.externalStatus,
    super.purpose,
  });

  factory BankDetaislModel.fromJson(Map<String, dynamic> json) {
    return BankDetaislModel(
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      bank: json['bank'],
      country: json['country'],
      purpose: json['purpose'],
      externalReference: json['external_reference'],
      externalStatus: json['external_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_name': accountName,
      'account_number': accountNumber,
      'bank': bank,
      'country': country,
      'purpose': purpose,
      'external_reference': externalReference,
      'external_status': externalStatus,
    };
  }
}
