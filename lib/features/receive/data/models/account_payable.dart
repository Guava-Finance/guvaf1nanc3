import 'package:guava/features/receive/domain/entities/account_payable.dart';

class AccountPayableModel extends AccountPayable {
  const AccountPayableModel({
    required super.accountName,
    required super.accountNumber,
    required super.bankName,
    required super.bankCode,
    required super.expiryDate,
    required super.reference,
    required super.currency,
  });

  factory AccountPayableModel.fromJson(Map<String, dynamic> json) {
    return AccountPayableModel(
      accountName: json['account_name'] as String,
      accountNumber: json['account_number'] as String,
      bankName: json['bank_name'] as String,
      bankCode: json['bank_code'] as String,
      expiryDate: DateTime.parse(json['expiry_date'].toString()),
      reference: json['reference'] as String,
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_name': accountName,
      'account_number': accountNumber,
      'bank_name': bankName,
      'bank_code': bankCode,
      'expiry_date': expiryDate.toIso8601String(),
      'reference': reference,
      'currency': currency,
    };
  }

  AccountPayableModel copyWith({
    String? accountName,
    String? accountNumber,
    String? bankName,
    String? bankCode,
    DateTime? expiryDate,
    String? reference,
    String? currency,
  }) {
    return AccountPayableModel(
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      bankCode: bankCode ?? this.bankCode,
      expiryDate: expiryDate ?? this.expiryDate,
      reference: reference ?? this.reference,
      currency: currency ?? this.currency,
    );
  }

  static List<AccountPayable> toList(List<dynamic> jsonList) {
    return jsonList
        .map((json) =>
            AccountPayableModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
