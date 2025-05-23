import 'dart:convert';
import 'package:equatable/equatable.dart';

class SplToken extends Equatable {
  final int chainId;
  final String address;
  final String symbol;
  final String name;
  final int decimals;
  final String logoURI;
  final List<String> tags;
  final Map<String, dynamic> extensions;

  const SplToken({
    required this.chainId,
    required this.address,
    required this.symbol,
    required this.name,
    required this.decimals,
    required this.logoURI,
    required this.tags,
    required this.extensions,
  });

  factory SplToken.fromJson(dynamic json) {
    final map = json is String ? jsonDecode(json) : json;
    return SplToken(
      chainId: map['chainId'],
      address: map['address'],
      symbol: map['symbol'],
      name: map['name'],
      decimals: map['decimals'],
      logoURI: map['logoURI'],
      tags: List<String>.from(map['tags'] ?? []),
      extensions: Map<String, dynamic>.from(map['extensions'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chainId': chainId,
      'address': address,
      'symbol': symbol,
      'name': name,
      'decimals': decimals,
      'logoURI': logoURI,
      'tags': tags,
      'extensions': extensions,
    };
  }

  SplToken copyWith({
    int? chainId,
    String? address,
    String? symbol,
    String? name,
    int? decimals,
    String? logoURI,
    List<String>? tags,
    Map<String, dynamic>? extensions,
  }) {
    return SplToken(
      chainId: chainId ?? this.chainId,
      address: address ?? this.address,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      decimals: decimals ?? this.decimals,
      logoURI: logoURI ?? this.logoURI,
      tags: tags ?? this.tags,
      extensions: extensions ?? this.extensions,
    );
  }

  static List<SplToken> toList(dynamic jsonList) {
    final list = jsonList is String ? jsonDecode(jsonList) : jsonList;
    return List<SplToken>.from(list.map((e) => SplToken.fromJson(e)));
  }

  @override
  List<Object?> get props => [
        chainId,
        address,
        symbol,
        name,
        decimals,
        logoURI,
        tags,
        extensions,
      ];
}
