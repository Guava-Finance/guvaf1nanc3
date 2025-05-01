
class WalletTransferParam {
  final String? type;
  final String? amount;
  final String? senderAddress;
  final String? recipientAddress;
  final String? transactionFee;
  final String? signedTransaction;

  const WalletTransferParam({
    this.type,
    this.amount,
    this.senderAddress,
    this.recipientAddress,
    this.transactionFee,
    this.signedTransaction,
  });

  factory WalletTransferParam.fromJson(Map<String, dynamic> json) {
    return WalletTransferParam(
      type: json['type'],
      amount: json['amount'],
      senderAddress: json['sender_address'],
      recipientAddress: json['recipient_address'],
      transactionFee: json['transaction_fee'],
      signedTransaction: json['signed_transaction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'sender_address': senderAddress,
      'recipient_address': recipientAddress,
      'transaction_fee': transactionFee,
      'signed_transaction': signedTransaction,
    };
  }

  WalletTransferParam copyWith({
    String? type,
    String? amount,
    String? senderAddress,
    String? recipientAddress,
    String? transactionFee,
    String? signedTransaction,
  }) {
    return WalletTransferParam(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      senderAddress: senderAddress ?? this.senderAddress,
      recipientAddress: recipientAddress ?? this.recipientAddress,
      transactionFee: transactionFee ?? this.transactionFee,
      signedTransaction: signedTransaction ?? this.signedTransaction,
    );
  }
}
