import 'package:guava/features/transfer/domain/entities/bank_beneficiary.dart';

class BankBeneficiaryModel extends BankBeneficiary {
  const BankBeneficiaryModel({
    required super.accountName,
    required super.accountNumber,
    required super.bank,
    required super.country,
    required super.createdAt,
  });

  factory BankBeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BankBeneficiaryModel(
      accountName: json['account_name'] ?? 'no-name',
      accountNumber: json['account_number'] ?? 'no-number',
      bank: json['bank'] ?? 'no-bank',
      country: json['country'] ?? 'no-country',
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_name': accountName,
      'account_number': accountNumber,
      'bank': bank,
      'country': country,
      'created_at': createdAt.toIso8601String(),
    };
  }

  BankBeneficiaryModel copyWith({
    String? accountName,
    String? accountNumber,
    String? bank,
    String? country,
    DateTime? createdAt,
  }) {
    return BankBeneficiaryModel(
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bank: bank ?? this.bank,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static List<BankBeneficiary> toList(List<dynamic> jsonList) {
    return jsonList
        .map((json) =>
            BankBeneficiaryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
