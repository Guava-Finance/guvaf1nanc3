import 'package:equatable/equatable.dart';
import 'package:guava/features/home/data/models/bank.dart';
import 'package:guava/features/home/domain/entities/bank_details.dart';

class TransactionsHistory extends Equatable {
  final String? id;
  final String? type;
  final String? category;
  final double? amount;
  final String? currency;
  final String? reason;
  final String? transactionId;
  final String? explorerTransactionId;
  final String? status;
  final String? sender;
  final String? recipient;
  final DateTime? timestamp;
  final BankDetaislModel? bankDetails;

  const TransactionsHistory({
    this.id,
    this.type,
    this.category,
    this.amount,
    this.currency,
    this.reason,
    this.transactionId,
    this.explorerTransactionId,
    this.status,
    this.sender,
    this.recipient,
    this.timestamp,
    this.bankDetails,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        category,
        amount,
        currency,
        reason,
        transactionId,
        explorerTransactionId,
        status,
        sender,
        recipient,
        timestamp,
        bankDetails,
      ];
}
