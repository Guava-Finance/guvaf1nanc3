import 'package:guava/features/home/data/models/bank.dart';
import 'package:guava/features/home/domain/entities/transaction_history.dart';

class TransactionHistoryModel extends TransactionsHistory {
  const TransactionHistoryModel({
    super.amount,
    super.bankDetails,
    super.category,
    super.currency,
    super.explorerTransactionId,
    super.id,
    super.reason,
    super.recipient,
    super.sender,
    super.status,
    super.timestamp,
    super.transactionId,
    super.type,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryModel(
      id: json['id'],
      type: json['type'],
      category: json['category'],
      amount: num.tryParse(json['amount'])?.toDouble(),
      currency: json['currency'],
      reason: json['reason'],
      transactionId: json['transaction_id'],
      explorerTransactionId: json['explorer_transaction_id'],
      status: json['status'],
      sender: json['sender'],
      recipient: json['recipient'],
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      bankDetails: json['bank_details'] != 'null'
          ? BankDetaislModel.fromJson(json['bank_details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'amount': amount,
      'currency': currency,
      'reason': reason,
      'transaction_id': transactionId,
      'explorer_transaction_id': explorerTransactionId,
      'status': status,
      'sender': sender,
      'recipient': recipient,
      'timestamp': timestamp?.toIso8601String(),
      'bank_details': bankDetails?.toJson(),
    };
  }

  TransactionsHistory copyWith({
    String? id,
    String? type,
    String? category,
    double? amount,
    String? currency,
    String? reason,
    String? transactionId,
    String? explorerTransactionId,
    String? status,
    String? sender,
    String? recipient,
    DateTime? timestamp,
    BankDetaislModel? bankDetails,
  }) {
    return TransactionsHistory(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      reason: reason ?? this.reason,
      transactionId: transactionId ?? this.transactionId,
      explorerTransactionId:
          explorerTransactionId ?? this.explorerTransactionId,
      status: status ?? this.status,
      sender: sender ?? this.sender,
      recipient: recipient ?? this.recipient,
      timestamp: timestamp ?? this.timestamp,
      bankDetails: bankDetails ?? this.bankDetails,
    );
  }

  static List<TransactionHistoryModel> toList(List<dynamic> data) {
    return data.map((e) => TransactionHistoryModel.fromJson(e)).toList();
  }
}
