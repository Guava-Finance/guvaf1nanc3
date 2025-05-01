import 'package:guava/features/transfer/domain/entities/recent_bank_transfer.dart';

class RecentBankTransferModel extends RecentBankTransfer {
  const RecentBankTransferModel({
    required super.accountName,
    required super.accountNumber,
    required super.bank,
    required super.country,
    required super.amount,
    required super.date,
    required super.status,
  });

  factory RecentBankTransferModel.fromJson(Map<String, dynamic> json) {
    return RecentBankTransferModel(
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      bank: json['bank'],
      country: json['country'],
      amount: num.tryParse(json['amount'].toString())?.toDouble() ?? 0.0,
      date: DateTime.tryParse(json['date'].toString()) ?? DateTime.now(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_name': accountName,
      'account_number': accountNumber,
      'bank': bank,
      'country': country,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  RecentBankTransferModel copyWith({
    String? accountName,
    String? accountNumber,
    String? bank,
    String? country,
    double? amount,
    DateTime? date,
    String? status,
  }) {
    return RecentBankTransferModel(
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bank: bank ?? this.bank,
      country: country ?? this.country,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  static List<RecentBankTransferModel> toList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => RecentBankTransferModel.fromJson(json))
        .toList();
  }
}
