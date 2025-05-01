import 'package:guava/features/transfer/domain/entities/ccountry.dart';

class SupportedCountryModel extends Country {
  const SupportedCountryModel({
    required super.name,
    required super.code,
    required super.currency,
    required super.currencyCode,
    required super.currencySymbol,
  });

  // Factory constructor to create a Country from JSON
  factory SupportedCountryModel.fromJson(Map<String, dynamic> json) {
    return SupportedCountryModel(
        name: json['name'] as String,
        code: json['code'] as String,
        currency: json['currency'] as String,
        currencyCode: json['currency_code'] as String,
        currencySymbol: json['currency_symbol'] as String);
  }

  // Method to convert SupportedCountryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'currency': currency,
      'currency_symbol': currencySymbol,
      'currency_code': currencyCode,
    };
  }

  SupportedCountryModel copyWith({
    String? name,
    String? code,
    String? currency,
    String? currencyCode,
    String? currencySymbol,
  }) {
    return SupportedCountryModel(
      name: name ?? this.name,
      code: code ?? this.code,
      currency: currency ?? this.currency,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }

  static List<SupportedCountryModel> toList(List data) {
    return data.map((e) => SupportedCountryModel.fromJson(e)).toList();
  }
}
