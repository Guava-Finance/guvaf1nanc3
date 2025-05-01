import 'package:guava/features/transfer/domain/entities/account_detail.dart';

class AccountDetailModel extends AccountDetail {
  const AccountDetailModel({
    required super.bankName,
    required super.bankCode,
    required super.accountNumber,
    required super.accountName,
  });

  factory AccountDetailModel.fromJson(Map<String, dynamic> json) {
    return AccountDetailModel(
      bankName: json['bank_name'],
      bankCode: json['bank_code'],
      accountNumber: json['account_number'],
      accountName: json['account_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_name': bankName,
      'bank_code': bankCode,
      'account_number': accountNumber,
      'account_name': accountName,
    };
  }

  AccountDetailModel copyWith({
    String? bankName,
    String? bankCode,
    String? accountNumber,
    String? accountName,
  }) {
    return AccountDetailModel(
      bankName: bankName ?? this.bankName,
      bankCode: bankCode ?? this.bankCode,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
    );
  }

  static List<AccountDetail> toList(List<dynamic> jsonList) {
    return jsonList
        .map(
            (json) => AccountDetailModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
