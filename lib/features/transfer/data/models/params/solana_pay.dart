class SolanaPayUrl {
  final String recipient;
  final String? amount;
  final String? splToken;
  final String? reference;
  final String? label;
  final String? message;
  final String? memo;
  final String? fee;

  SolanaPayUrl({
    required this.recipient,
    this.amount,
    this.splToken,
    this.reference,
    this.label,
    this.message,
    this.memo,
    this.fee,
  });

  SolanaPayUrl copyWith({
    String? recipient,
    String? amount,
    String? splToken,
    String? reference,
    String? label,
    String? message,
    String? memo,
    String? fee,
    // Use these parameters when you want to explicitly set a value to null
    bool clearAmount = false,
    bool clearSplToken = false,
    bool clearReference = false,
    bool clearLabel = false,
    bool clearMessage = false,
    bool clearMemo = false,
    bool clearFee = false,
  }) {
    return SolanaPayUrl(
      recipient: recipient ?? this.recipient,
      amount: clearAmount ? null : amount ?? this.amount,
      splToken: clearSplToken ? null : splToken ?? this.splToken,
      reference: clearReference ? null : reference ?? this.reference,
      label: clearLabel ? null : label ?? this.label,
      message: clearMessage ? null : message ?? this.message,
      memo: clearMemo ? null : memo ?? this.memo,
      fee: clearFee ? null : fee ?? this.fee,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'amount': amount,
      'splToken': splToken,
      'reference': reference,
      'label': label,
      'message': message,
      'memo': memo,
      'fee': fee,
    };
  }

  @override
  String toString() {
    return '''
    SolanaPayUrl:
      recipient: $recipient
      amount: $amount
      splToken: $splToken
      reference: $reference
      label: $label
      message: $message
      memo: $memo
      fee: $fee
    ''';
  }
}
