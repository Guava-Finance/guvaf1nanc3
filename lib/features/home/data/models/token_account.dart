import 'package:guava/features/home/data/models/spl_token.dart';
import 'dart:convert';

class TokenAccount {
  final String mint;
  final String owner;
  final double amount;
  final SplToken? splToken;

  TokenAccount({
    required this.mint,
    required this.owner,
    required this.amount,
    this.splToken,
  });

  factory TokenAccount.fromJson(dynamic json) {
    final map = json is String ? jsonDecode(json) : json;
    return TokenAccount(
      mint: map['mint'],
      owner: map['owner'],
      amount: map['amount'],
      splToken:
          map['splToken'] != null ? SplToken.fromJson(map['splToken']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mint': mint,
      'owner': owner,
      'amount': amount,
      'splToken': splToken?.toJson(),
    };
  }

  TokenAccount copyWith({
    String? mint,
    String? owner,
    double? amount,
    SplToken? splToken,
  }) {
    return TokenAccount(
      mint: mint ?? this.mint,
      owner: owner ?? this.owner,
      amount: amount ?? this.amount,
      splToken: splToken ?? this.splToken,
    );
  }

  static List<TokenAccount> toList(dynamic jsonList) {
    final list = jsonList is String ? jsonDecode(jsonList) : jsonList;
    return List<TokenAccount>.from(list.map((e) => TokenAccount.fromJson(e)));
  }
}
