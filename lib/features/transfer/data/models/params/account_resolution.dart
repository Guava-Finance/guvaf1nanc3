class AccountResolutionParam {
  AccountResolutionParam({
    this.account,
    this.bank,
  });

  final String? bank;
  final String? account;

  factory AccountResolutionParam.fromJson(Map<String, dynamic> json) {
    return AccountResolutionParam(
      account: json['account'],
      bank: json['bank'],
    );
  }

  Map<String, dynamic> toJson() => {
        'bank': bank,
        'account': account,
      };

  AccountResolutionParam copyWith({String? bank, String? account}) {
    return AccountResolutionParam(
      bank: bank ?? this.bank,
      account: account ?? this.account,
    );
  }
}