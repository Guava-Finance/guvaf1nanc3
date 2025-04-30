import 'package:guava/features/transfer/domain/entities/bank.dart';

class BankModel extends Bank {
  const BankModel({
    required super.name,
    required super.slug,
    required super.code,
    required super.country,
    required super.nibssBankCode,
  });

  // Factory constructor to create a Bank from JSON
  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      name: json['name'] as String,
      slug: json['slug'] as String,
      code: json['code'] as String,
      country: json['country'] as String,
      nibssBankCode: json['nibss_bank_code'] as String,
    );
  }

  // Method to convert Bank to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'code': code,
      'country': country,
      'nibss_bank_code': nibssBankCode,
    };
  }

  // CopyWith method to create a new Bank with some properties changed
  BankModel copyWith({
    String? name,
    String? slug,
    String? code,
    String? country,
    String? nibssBankCode,
  }) {
    return BankModel(
      name: name ?? this.name,
      slug: slug ?? this.slug,
      code: code ?? this.code,
      country: country ?? this.country,
      nibssBankCode: nibssBankCode ?? this.nibssBankCode,
    );
  }

  static List<Bank> toList(List data) {
    return data.map((e) => BankModel.fromJson(e)).toList();
  }
}
