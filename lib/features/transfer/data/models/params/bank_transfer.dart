class BankTransferParam {
  final String? type;
  final String? amount;
  final String? country;
  final String? bank;
  final String? bankCode;
  final String? accountName;
  final String? accountNumber;
  final String? purpose;
  final String? transactionFee;
  final String? signedTransaction;

  BankTransferParam({
    this.type,
    this.amount,
    this.country,
    this.bank,
    this.bankCode,
    this.accountName,
    this.accountNumber,
    this.purpose,
    this.transactionFee,
    this.signedTransaction,
  });

  factory BankTransferParam.fromJson(Map<String, dynamic> json) {
    return BankTransferParam(
      type: json['type'],
      amount: json['amount'],
      country: json['country'],
      bank: json['bank'],
      bankCode: json['bank_code'],
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      purpose: json['purpose'],
      transactionFee: json['transaction_fee'],
      signedTransaction: json['signed_transaction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'country': country,
      'bank': bank,
      'bank_code': bankCode,
      'account_name': accountName,
      'account_number': accountNumber,
      'purpose': purpose,
      'transaction_fee': transactionFee,
      'signed_transaction': signedTransaction,
    };
  }

  BankTransferParam copyWith({
    String? type,
    String? amount,
    String? country,
    String? bank,
    String? bankCode,
    String? accountName,
    String? accountNumber,
    String? purpose,
    String? transactionFee,
    String? signedTransaction,
  }) {
    return BankTransferParam(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      country: country ?? this.country,
      bank: bank ?? this.bank,
      bankCode: bankCode ?? this.bankCode,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      purpose: purpose ?? this.purpose,
      transactionFee: transactionFee ?? this.transactionFee,
      signedTransaction: signedTransaction ?? this.signedTransaction,
    );
  }
}
