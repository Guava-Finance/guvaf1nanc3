class BalanceParam {
  final double usdcBalance;
  final double exchangeRate;
  final double localBalance;
  final String symbol;

  const BalanceParam({
    required this.usdcBalance,
    required this.exchangeRate,
    required this.localBalance,
    required this.symbol,
  });

  factory BalanceParam.fromJson(Map<String, dynamic> json) {
    final usdc =
        num.tryParse(json['usdcBalance']?.toString() ?? '')?.toDouble() ?? 0.0;
    final rate =
        num.tryParse(json['exchangeRate']?.toString() ?? '')?.toDouble() ?? 1.0;

    return BalanceParam(
      usdcBalance: usdc,
      exchangeRate: rate,
      localBalance: usdc / rate,
      symbol: json['symbol'] ?? '₦',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usdcBalance': usdcBalance,
      'exchangeRate': exchangeRate,
      'localBalance': localBalance,
      'symbol': symbol,
    };
  }

  BalanceParam copyWith({
    double? usdcBalance,
    double? exchangeRate,
    double? localBalance,
    String? symbol,
  }) {
    return BalanceParam(
      usdcBalance: usdcBalance ?? this.usdcBalance,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      localBalance: localBalance ?? this.localBalance,
      symbol: symbol ?? this.symbol,
    );
  }
}
