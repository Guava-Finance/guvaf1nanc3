

import 'package:guava/features/onboarding/data/models/config/country.model.dart';
import 'package:guava/features/onboarding/domain/entities/config/country.entity.dart';
import 'package:guava/features/onboarding/domain/entities/config/guava_pay.entity.dart';

class GuavaPayModel extends GuavaPayEntity {
  const GuavaPayModel({
    required super.businessWalletDerivativePaths,
    required super.countries,
  });

  factory GuavaPayModel.fromJson(Map<String, dynamic> json) {
    return GuavaPayModel(
      businessWalletDerivativePaths:
          List<String>.from(json['business_wallet_derivative_paths']),
      countries: (json['countries'] as List)
          .map((e) => CountryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business_wallet_derivative_paths': businessWalletDerivativePaths,
      'countries': countries.map((e) => (e as CountryModel).toJson()).toList(),
    };
  }

  GuavaPayModel copyWith({
    List<String>? businessWalletDerivativePaths,
    List<CountryEntity>? countries,
  }) {
    return GuavaPayModel(
      businessWalletDerivativePaths:
          businessWalletDerivativePaths ?? this.businessWalletDerivativePaths,
      countries: countries ?? this.countries,
    );
  }
}
