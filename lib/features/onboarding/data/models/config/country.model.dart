import 'package:guava/features/onboarding/data/models/config/rates.model.dart';
import 'package:guava/features/onboarding/domain/entities/config/country.entity.dart';
import 'package:guava/features/onboarding/domain/entities/config/rate.entity.dart';

class CountryModel extends CountryEntity {
  const CountryModel({
    required super.name,
    required super.countryCode,
    required super.currency,
    required super.currencyCode,
    required super.currencySymbol,
    required super.callingCode,
    required super.phoneLength,
    required super.kycPartners,
    required super.kybPartners,
    required super.rates,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'],
      countryCode: json['country_code'],
      currency: json['currency'],
      currencyCode: json['currency_code'],
      currencySymbol: json['currency_symbol'],
      callingCode: json['calling_code'],
      phoneLength: List<int>.from((json['phone_length'] as List)
          .map((e) => int.parse(e.toString()))
          .toList()),
      kycPartners: json['kyc_partners'] == null
          ? null
          : List<String>.from(json['kyc_partners']),
      kybPartners: json['kyb_partners'] == null
          ? null
          : List<String>.from(json['kyb_partners']),
      rates: RatesModel.fromJson(json['rates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country_code': countryCode,
      'currency': currency,
      'currency_code': currencyCode,
      'currency_symbol': currencySymbol,
      'calling_code': callingCode,
      'phone_length': phoneLength,
      'kyc_partners': kycPartners,
      'rates': (rates as RatesModel).toJson(),
    };
  }

  CountryModel copyWith({
    String? name,
    String? countryCode,
    String? currency,
    String? currencyCode,
    String? currencySymbol,
    String? callingCode,
    List<int>? phoneLength,
    List<String>? kycPartners,
    List<String>? kybPartners,
    RatesEntity? rates,
  }) {
    return CountryModel(
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      currency: currency ?? this.currency,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      callingCode: callingCode ?? this.callingCode,
      phoneLength: phoneLength ?? this.phoneLength,
      kycPartners: kycPartners ?? this.kycPartners,
      kybPartners: kybPartners ?? this.kybPartners,
      rates: rates ?? this.rates,
    );
  }
}
